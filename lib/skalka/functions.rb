require "json"
require "transproc"
require "transproc/conditional"

module Skalka
  module Functions
    MAIN_FIELDS = %i[id type attributes].freeze
    EXTRA_FIELDS = %i[errors links meta].freeze

    extend Transproc::Registry

    import Transproc::ArrayTransformations
    import Transproc::Conditional
    import Transproc::HashTransformations

    import :parse, from: JSON, as: :parse_json

    module_function

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

    def pick_main_attributes(item)
      item.slice(*MAIN_FIELDS)
    end
  end
end
