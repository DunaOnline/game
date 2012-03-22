require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Vote.new.valid?
  end
end
