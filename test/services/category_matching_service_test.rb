require 'test_helper'

class CategoryMatchingServiceTest < ActiveSupport::TestCase
  def test_handles_category_data_with_special_characters
    user = users(:peter)
    category_data = ["something' weird!", "food"]

    service = CategoryMatchingService.new(user: user, category_data: category_data)
    service.run

    assert_equal categories(:food), service.matched_category
  end
end
