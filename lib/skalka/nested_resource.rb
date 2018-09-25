module Skalka
  module NestedResource
    extend Transproc::Registry

    module_function

    def build(item)
      return {} if item.empty?

      Functions[:deep_merge][
        Functions[:pick_main_attributes][item],
        attributes: attributes(item)
      ]
    end

    private def attributes(item)
      (
        Resource[:fetch_relationships] >>
        Functions[:map_values, fetch_and_reject_type]
      )[item]
    end

    private def fetch_and_reject_type
      Functions[:fetch_data] >> Functions[:map_or_pass][
        Functions[:reject_keys, [:type]]
      ]
    end
  end
end
