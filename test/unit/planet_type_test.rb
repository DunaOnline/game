require 'test_helper'

class PlanetTypeTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert PlanetType.new.valid?
  end
end
