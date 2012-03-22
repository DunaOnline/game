require 'test_helper'

class HouseTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert House.new.valid?
  end
end
