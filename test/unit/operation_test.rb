require 'test_helper'

class OperationTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Operation.new.valid?
  end
end
