module Skalka
  module Resource
    extend Transproc::Registry

    module_function

    def build_resource(item, parsed_json)
      raw_relationships = item.fetch(:relationships, {})
      included = parsed_json.fetch(:included, [])

      {
        **self[:deattribute][item],
        **relationships(included, raw_relationships)
      }
    end

    def deattribute(item)
      {
        id: item[:id].to_i,
        **item[:attributes]
      }
    end

    def deattribute_with_nested(item)
      {
        **deattribute(item),
        **nested_relationships(item.fetch(:relationships, {}))
      }
    end

    def nested_relationships(relationships)
      Functions[
        :map_values,
        Functions[:fetch_data] >>
        Functions[:flat_wrap] >>
        Functions[
          :map_array,
          Functions[:accept_keys, [:id]] >>
          Functions[:map_value, :id, ->(id) { id.to_i }]
        ]
      ][relationships]
    end

    def fetch_link(included)
      Functions[:fetch_data] >>
        Functions[:flat_wrap] >>
        Functions[:map_array, self[:find_resource].with(included) >> self[:deattribute_with_nested]] >>
        Functions[:unwrap]
    end

    def find_resource(relationship, included)
      included.find do |included_resource|
        included_resource.values_at(:id, :type) == relationship.values_at(:id, :type)
      end
    end

    def relationships(included, raw_relationships)
      Functions[:map_values, fetch_link(included)][raw_relationships]
    end
  end
end
