require 'test_helper'

class PropertyTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Property.new.valid?
  end
end
