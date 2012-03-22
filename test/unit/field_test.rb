require 'test_helper'

class FieldTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Field.new.valid?
  end
end
