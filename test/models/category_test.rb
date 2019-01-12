require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  def setup
    @user = users(:peter)
  end

  def test_scope_should_calculate_budget_and_spending_this_month
    categories = @user.categories.with_budget_and_spending_for_month(this_month)

    assert_equal 2, categories.to_a.size
    food = categories.first
    purchases = categories.last

    assert_equal 175, food.spending
    assert_equal 600, food.budget

    assert_equal 80, purchases.spending
    assert_equal 200, purchases.budget
  end

  def test_scope_should_calculate_budget_and_spending_last_month
    categories = @user.categories.with_budget_and_spending_for_month(last_month)

    assert_equal 2, categories.to_a.size
    food = categories.first
    purchases = categories.last

    assert_equal 170, food.spending
    assert_equal 600, food.budget

    assert_equal 65, purchases.spending
    assert_equal 200, purchases.budget
  end

  def test_recurring_transactions_included_in_each_month
    categories = @user.categories.with_budget_and_spending_for_month(this_month)
    categories_last_month = @user.categories.with_budget_and_spending_for_month(last_month)

    assert_equal 175, categories.first.spending
    assert_equal 170, categories_last_month.first.spending

    recurring = Transaction.create!(
                  name: 'Bamboo', user: @user, category: categories(:food),
                  sub_category: sub_categories(:eating_out), amount: 12.50, recurring: true
                )

    categories.reload
    categories_last_month.reload

    assert_equal 187.50, categories.first.spending
    assert_equal 182.50, categories_last_month.first.spending
  end
end
