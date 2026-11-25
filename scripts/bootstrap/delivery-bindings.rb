#!/usr/bin/env ruby
require "json"
require "optparse"
require "yaml"

root = File.expand_path("../..", __dir__)
options = {context: File.join(root, "config/customer-context.yaml"),
           proposal: File.join(root, "workspace/bootstrap/proposal.json")}
parser = OptionParser.new do |p|
  p.banner = "Usage: delivery-bindings.rb --scope SCOPE [--context PATH] [--proposal PATH] [--preview]"
  p.on("--scope SCOPE") { |v| options[:scope] = v }
  p.on("--context PATH") { |v| options[:context] = v }
  p.on("--proposal PATH") { |v| options[:proposal] = v }
  p.on("--preview", "Show a proposed refresh for review") { options[:preview] = true }
end
parser.parse!
abort parser.to_s unless options[:scope] && ARGV.empty?

# A lookup locates evidence and destinations. It never invokes a connector.
catalog = {
  "request" => "change_delivery", "service_inventory" => "asset_service_context",
  "target_environment" => "source_configuration", "declared_version" => "source_configuration", "observed_version" => "resource_control",
  "release_checks" => "operational_assurance", "announcement_destination" => "change_delivery",
  "infrastructure_docs" => "knowledge_evidence"
}
context_path = options[:context]
proposal_path = options[:proposal]
validate = File.join(root, "tests/validate-schema-example.rb")
abort "invalid customer context" unless system("ruby", validate, File.join(root, "schemas/customer-context.schema.json"), context_path, out: File::NULL)
context = YAML.safe_load(File.read(context_path), permitted_classes: [], aliases: true)
proposal = nil
if File.file?(proposal_path)
  abort "invalid bootstrap proposal" unless system(File.join(root, "scripts/bootstrap/validate-proposal.sh"), "--proposal", proposal_path, out: File::NULL)
  proposal = JSON.parse(File.read(proposal_path))
  abort "proposal belongs to a different customer" unless proposal["customer"]["id"] == context["customer"]["id"]
end
abort "preview requires a bootstrap proposal" if options[:preview] && !proposal
planes = context.fetch("management_planes")
proposed = proposal ? proposal.fetch("bindings").to_h { |b| [b.fetch("plane"), b] } : {}
scope = options.fetch(:scope)
rows = catalog.map do |name, plane|
  active = planes.fetch(plane)
  plan = proposed.fetch(plane, {})
  source = options[:preview] ? plan : active
  matches = Array(source["capabilities"]).select { |r| r["name"] == name && r["scope"] == scope }
  approved = Array(plan["capabilities"]).select { |r| r["name"] == name && r["scope"] == scope }
  fallback_owner = plan["owner"] || active.fetch("systems").first&.fetch("owner") || context.fetch("customer").fetch("accountable_owner")
  owner = matches.one? ? matches.first.fetch("owner") : fallback_owner
  result = {"name" => name, "scope" => scope, "plane" => plane, "owner" => owner}
  reason = if matches.empty?
    "No explicit binding for this capability and scope"
  elsif matches.size != 1
    "Ambiguous binding"
  elsif !options[:preview] && !(proposal && proposal["status"] == "approved" && matches == approved)
    "Active binding lacks a matching approved proposal"
  end
  record = matches.first
  if reason
    result.merge("status" => "gap", "reason" => reason)
  elsif record["status"] != "bound"
    result.merge(record.slice("owner", "status", "reason"))
  elsif !%w[bound read-only].include?(source["status"]) ||
        (!options[:preview] && (context["readiness"] == "partial" || !%w[bound read-only].include?(plan["status"])))
    result.merge("owner" => record["owner"], "status" => "gap", "reason" => "Bootstrap or management plane lacks readiness")
  elsif record["operation"] != "read" && (source["status"] == "read-only" || plan["status"] == "read-only")
    result.merge("owner" => record["owner"], "status" => "gap", "reason" => "Plane permits reads only")
  else
    result.merge(record).merge("status" => options[:preview] ? "proposed" : "configured")
  end
end
puts JSON.pretty_generate({"customer" => context["customer"]["id"], "scope" => scope,
                           "mode" => options[:preview] ? "preview" : "active", "capabilities" => rows})
exit(rows.all? { |r| %w[configured proposed].include?(r["status"]) } ? 0 : 2)
