require 'test_helper'

class SubhouseTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Subhouse.new.valid?
  end
end
