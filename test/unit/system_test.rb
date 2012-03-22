require 'test_helper'

class SystemTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert System.new.valid?
  end
end
