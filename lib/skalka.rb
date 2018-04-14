require "skalka/functions"
require "skalka/resource"
require "skalka/nested_resource"
require "skalka/version"

module Skalka
  autoload :Functions, "skalka/functions"
  autoload :Resource, "skalka/resource"
  autoload :NestedResource, "skalka/nested_resource"

  module_function

  def call(json)
    parsed_json = Functions[:parse_and_symbolize_keys][json]

    {
      data: Functions[:extract_resource][parsed_json],
      **Functions[:extra_fields][parsed_json]
    }
  end
end
