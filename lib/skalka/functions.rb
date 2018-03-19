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

    UNWRAP_GUARD = Functions[:guard, ->(list) { list.one? }, ->(list) { list.first }]

    module_function

    def fetch_data(item)
      item.fetch(:data, {})
    end

    def flat_wrap(data)
      [data].flatten
    end

    def extra_fields(parsed_json)
      parsed_json.slice(*EXTRA_FIELDS)
    end

    def extract(parsed_json)
      (
        self[:fetch_data] >>
        self[:flat_wrap] >>
        self[:map_array, Resource[:build_resource].with(parsed_json)] >>
        self[:unwrap]
      ).call(parsed_json)
    end

    def unwrap(list)
      Functions[:guard, ->(l) { l.one? }, ->(l) { l.first }][list]
    end
  end
end
