require 'test_helper'

class EodTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Eod.new.valid?
  end
end
