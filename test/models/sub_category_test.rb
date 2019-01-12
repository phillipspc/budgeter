require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  def setup
    @user = users(:peter)
  end

  def test_scope_should_calculate_spending_this_month
    sub_categories = @user.sub_categories.with_spending_for_month(this_month).order("name")

    assert_equal 4, sub_categories.to_a.size
    assert_equal ["clothes", "eating_out", "groceries", "household_supplies"], sub_categories.map(&:name)
    assert_equal [30, 75, 100, 50], sub_categories.map(&:spending)
  end

  def test_scope_should_calculate_spending_last_month
    sub_categories = @user.sub_categories.with_spending_for_month(last_month).order("name")

    assert_equal 4, sub_categories.to_a.size
    assert_equal ["clothes", "eating_out", "groceries", "household_supplies"], sub_categories.map(&:name)
    assert_equal [40, 70, 100, 25], sub_categories.map(&:spending)
  end

  def test_recurring_transactions_included_in_each_month
    sub_categories = @user.sub_categories.with_spending_for_month(this_month).order("name")
    sub_categories_last_month = @user.sub_categories.with_spending_for_month(last_month).order("name")

    assert_equal 30, sub_categories.first.spending
    assert_equal 40, sub_categories_last_month.first.spending

    recurring = Transaction.create!(
                  name: 'Underwear', user: @user, category: categories(:purchases),
                  sub_category: sub_categories(:clothes), amount: 12.50, recurring: true
                )

    sub_categories.reload
    sub_categories_last_month.reload

    assert_equal 42.50, sub_categories.first.spending
    assert_equal 52.50, sub_categories_last_month.first.spending
  end
end
