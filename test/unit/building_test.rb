require 'test_helper'

class BuildingTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Building.new.valid?
  end
end
