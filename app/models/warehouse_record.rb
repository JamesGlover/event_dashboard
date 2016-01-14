# frozen_string_literal: true
# Provides a base class for all Warehouse Records, we should probably be doing this through an api

require 'activeuuid'

class WarehouseRecord < ActiveRecord::Base
  establish_connection ENV["event_warehouse_db_#{Rails.env}"]||configurations['event_warehouse'][Rails.env]
  ActiveUUID::Patches.apply!

  self.abstract_class = true

  default_scope -> { readonly(true) }

end
