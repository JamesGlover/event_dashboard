module ModelHelpers
  module TableHelpers

    def roles_table
      Warehouse::Role.arel_table
    end

    def subjects_table
      Warehouse::Subject.arel_table
    end

    def events_table
      Warehouse::Event.arel_table
    end

  end
end
