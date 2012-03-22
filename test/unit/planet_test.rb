require 'test_helper'

class PlanetTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Planet.new.valid?
  end
end
