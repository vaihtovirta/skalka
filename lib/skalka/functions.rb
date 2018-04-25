require "json"
require "transproc"
require "transproc/conditional"

module Skalka
  module Functions
    EXTRA_FIELDS = %i[errors links meta].freeze

    extend Transproc::Registry

    import Transproc::ArrayTransformations
    import Transproc::Conditional
    import Transproc::HashTransformations

    import :parse, from: JSON, as: :parse_json

    module_function

    def deattribute(item)
      return {} if item.empty?

      {
        id: item[:id].to_i,
        **item[:attributes]
      }
    end

    def fetch_data(item)
      item.fetch(:data, {})
    end

    def extra_fields(parsed_json)
      parsed_json.slice(*EXTRA_FIELDS)
    end

    def extract_resource(parsed_json)
      included = parsed_json.fetch(:included, [])

      (
        self[:fetch_data] >>
        self[:map_or_pass][ Resource[:build].with(included) ]
      ).call(parsed_json)
    end

    def map_or_pass(func)
      self[:is, Array, self[:map_array, func]] >> self[:is, Hash, func]
    end

    def parse_and_symbolize_keys(json)
      (self[:parse_json] >> self[:deep_symbolize_keys]).call(json)
    end
  end
end
