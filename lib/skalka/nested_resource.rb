module Skalka
  module NestedResource
    extend Transproc::Registry

    module_function

    def build(item)
      (
        Resource[:fetch_relationships] >>
        Functions[:map_values, fetch_and_process_data]
      )[item]
    end

    private def fetch_and_process_data
      Functions[:fetch_data] >> Functions[:map_or_pass][reject_type_and_convert_id]
    end

    private def reject_type_and_convert_id
      Functions[:reject_keys, [:type]] >> Functions[:map_value, :id, ->(id) { id.to_i }]
    end
  end
end
