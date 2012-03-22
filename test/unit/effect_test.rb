require 'test_helper'

class EffectTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Effect.new.valid?
  end
end
