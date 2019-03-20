module ApplicationHelper
  def previous_month_for(month)
    (month.to_date - 1.month).beginning_of_month.strftime("%B %Y")
  end

  def next_month_for(month)
    (month.to_date + 1.month).beginning_of_month.strftime("%B %Y")
  end

  def budget_bar_klass(progress:, total:)
    case
    when progress >= total
      "is-danger"
    when (progress/total) >= 0.666
      "is-warning"
    else
      "is-success"
    end
  end

  def import_time(datetime)
    if datetime.localtime.to_date == Date.today
      datetime.localtime.strftime("%I:%M %p")
    else
      datetime.localtime.to_date
    end
  end
end
