module Skalka
  module Resource
    extend Transproc::Registry

    module_function

    def build(item, included)
      return {} if item.empty?

      Functions[:deep_merge][
        Functions[:pick_main_attributes][item],
        attributes: self[:relationships].with(included)[item]
      ]
    end

    def fetch_relationships(item)
      item.fetch(:relationships, {})
    end

    private def build_resource(included)
      self[:find_resource].with(included) >> NestedResource[:build]
    end

    private def fetch_link(included)
      Functions[:fetch_data] >> Functions[:map_or_pass][build_resource(included)]
    end

    private def find_resource(relationship, included)
      included.find do |included_resource|
        included_resource.values_at(:id, :type) == relationship.values_at(:id, :type)
      end
    end

    private def relationships(item, included)
      (
        self[:fetch_relationships] >>
        Functions[:map_values, fetch_link(included)]
      )[item]
    end
  end
end
