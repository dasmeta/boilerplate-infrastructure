#!/usr/bin/env ruby

require "json"
require "yaml"

schema_path, example_path = ARGV
abort "usage: #{$PROGRAM_NAME} SCHEMA.json EXAMPLE.yaml" unless schema_path && example_path

root_schema = JSON.parse(File.read(schema_path))
instance = YAML.safe_load(File.read(example_path), permitted_classes: [], aliases: true)
errors = []

def type_matches?(value, type)
  case type
  when "object" then value.is_a?(Hash)
  when "array" then value.is_a?(Array)
  when "string" then value.is_a?(String)
  when "boolean" then value == true || value == false
  when "integer" then value.is_a?(Integer)
  when "number" then value.is_a?(Numeric)
  when "null" then value.nil?
  else false
  end
end

validate = nil
validate = lambda do |value, schema, path|
  if schema.key?("$ref")
    target = schema["$ref"].delete_prefix("#/").split("/").reduce(root_schema) { |node, key| node.fetch(key) }
    validate.call(value, target, path)
    next
  end

  if schema.key?("const") && value != schema["const"]
    errors << "#{path}: expected constant #{schema['const'].inspect}"
  end

  if schema.key?("enum") && !schema["enum"].include?(value)
    errors << "#{path}: expected one of #{schema['enum'].inspect}"
  end

  types = Array(schema["type"]).compact
  unless types.empty? || types.any? { |type| type_matches?(value, type) }
    errors << "#{path}: expected #{types.join(' or ')}, got #{value.class}"
    next
  end

  if value.is_a?(Hash)
    Array(schema["required"]).each do |key|
      errors << "#{path}: missing required property #{key}" unless value.key?(key)
    end

    properties = schema.fetch("properties", {})
    value.each do |key, child|
      if properties.key?(key)
        validate.call(child, properties[key], "#{path}.#{key}")
      elsif schema["additionalProperties"] == false
        errors << "#{path}: unexpected property #{key}"
      elsif schema["additionalProperties"].is_a?(Hash)
        validate.call(child, schema["additionalProperties"], "#{path}.#{key}")
      end
    end
  end

  if value.is_a?(Array)
    errors << "#{path}: expected at least #{schema['minItems']} items" if schema["minItems"] && value.length < schema["minItems"]
    value.each_with_index { |child, index| validate.call(child, schema["items"], "#{path}[#{index}]") } if schema["items"]
  end

  if value.is_a?(String)
    errors << "#{path}: must not be empty" if schema["minLength"] && value.length < schema["minLength"]
    errors << "#{path}: does not match #{schema['pattern']}" if schema["pattern"] && !Regexp.new(schema["pattern"]).match?(value)
  end
end

validate.call(instance, root_schema, "$")

unless errors.empty?
  warn errors.join("\n")
  exit 1
end

puts "valid: #{File.basename(example_path)}"
