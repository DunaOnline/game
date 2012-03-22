require 'test_helper'

class DiscoverableTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Discoverable.new.valid?
  end
end
