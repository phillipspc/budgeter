require 'test_helper'

class PlaidImportTest < ActiveSupport::TestCase
  def setup
    @current_month = plaid_imports(:current_month)
    @last_month = plaid_imports(:last_month)
  end

  def test_does_not_need_update_if_current_month_and_updated_today
    assert Time.current - @current_month.updated_at < 24.hours
    assert_not @current_month.needs_update?
  end

  def test_needs_update_if_current_month_and_not_updated_today
    @current_month.touch(time: Time.current - 25.hours)
    assert Time.current - @current_month.updated_at > 24.hours
    assert @current_month.needs_update?
  end

  def test_needs_update_if_previous_month_and_not_updated_today_and_updated_less_than_a_week_after_months_end
    @last_month.touch(time: Time.current.prev_month)
    assert Time.current - @last_month.updated_at > 24.hours
    assert @last_month.updated_at < Time.current.prev_month.end_of_month + 1.week
    assert @last_month.needs_update?
  end

  def test_does_not_need_update_if_previous_month_and_updated_today
    @last_month.touch(time: Time.current)
    assert Time.current - @last_month.updated_at < 24.hours
    assert_not @last_month.needs_update?
  end

  def test_does_not_need_update_if_previous_month_and_not_updated_today_and_updated_more_than_a_week_after_months_end
    @last_month.touch(time: Time.current.prev_month.end_of_month + 8.days)
    assert_not @last_month.needs_update?
  end
end
