require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Topic.new.valid?
  end
end
