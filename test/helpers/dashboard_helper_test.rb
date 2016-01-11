require 'test_helper'

class DashboardHelperTest < ActiveSupport::TestCase

  include DashboardsHelper

  class PlateTester

    module TestHelpers
      def a_plate_made(age)
        PlateTester.new(self,age)
      end
    end

    attr_reader :suite, :created_at, :tat

    def initialize(suite,created_at)
      @suite = suite
      @created_at = created_at
    end

    def with_a_tat_of(days)
      @tat = days
      self
    end

    def age
      ((Time.now - 3.days.ago)/1.day).round(2)
    end

    def should_be(style)
      plate_created = created_at
      plate_tat = tat
      suite.test "A plate made #{age} days ago, with a tat of #{tat} days should be #{style}" do
        assert_equal style, status_colour(plate_created, plate_tat)
      end
    end

  end

  extend PlateTester::TestHelpers

  # New plates are green
  a_plate_made(0.5.days.ago).with_a_tat_of(3).should_be('success')
  # On time plates are blue
  a_plate_made(1.day.ago).with_a_tat_of(3).should_be('info')
  # Due plates are yellow
  a_plate_made(2.5.days.ago).with_a_tat_of(3).should_be('warning')
  # Overdue plates are red
  a_plate_made(3.5.days.ago).with_a_tat_of(3).should_be('danger')
  # New plates, still due today, are yellow
  a_plate_made(0.5.day.ago).with_a_tat_of(1).should_be('warning')

end
