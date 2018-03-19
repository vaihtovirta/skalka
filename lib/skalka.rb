require "skalka/functions"
require "skalka/resource"
require "skalka/version"

module Skalka
  autoload :Functions, "skalka/functions"
  autoload :Resource, "skalka/resource"

  module_function

  def call(json)
    parsed_json = parse_json(json)

    {
      data: Functions[:extract][parsed_json],
      **Functions[:extra_fields][parsed_json]
    }
  end

  private def parse_json(json)
    (Functions[:parse_json] >> Functions[:deep_symbolize_keys])[json]
  end
end
