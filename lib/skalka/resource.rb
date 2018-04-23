module Skalka
  module Resource
    extend Transproc::Registry

    module_function

    def build(item, included)
      {
        **Functions[:deattribute][item],
        **self[:relationships].with(included)[item]
      }
    end

    def deattribute_with_nested(item)
      {
        **self[:deattribute][item],
        **NestedResource[:build][item]
      }
    end

    def fetch_relationships(item)
      item.fetch(:relationships, {})
    end

    def fetch_link_func(included)
      Functions[:fetch_data] >> Functions[:map_or_pass][
        self[:find_resource].with(included) >> NestedResource[:build]
      ]
    end

    def find_resource(relationship, included)
      included.find do |included_resource|
        included_resource.values_at(:id, :type) == relationship.values_at(:id, :type)
      end
    end

    def relationships(item, included)
      (
        self[:fetch_relationships] >>
        Functions[:map_values, fetch_link_func(included)]
      )[item]
    end
  end
end
