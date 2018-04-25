require "skalka/functions"
require "skalka/resource"
require "skalka/nested_resource"
require "skalka/version"

module Skalka
  autoload :Functions, "skalka/functions"
  autoload :Resource, "skalka/resource"
  autoload :NestedResource, "skalka/nested_resource"

  NullJsonError = Class.new(StandardError)

  module_function

  def call(json)
    raise_null_json_error if json.nil?

    parsed_json = Functions[:parse_and_symbolize_keys][json]

    {
      data: Functions[:extract_resource][parsed_json],
      **Functions[:extra_fields][parsed_json]
    }
  end

  private def raise_null_json_error
    raise NullJsonError, "JSON is nil"
  end
end
