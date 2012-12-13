require 'test_helper'

class SyselaadTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Syselaad.new.valid?
  end
end
