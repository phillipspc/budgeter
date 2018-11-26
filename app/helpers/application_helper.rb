module ApplicationHelper
  def previous_month_for(month)
    (month.to_date - 1.month).beginning_of_month.strftime("%B %Y")
  end

  def next_month_for(month)
    (month.to_date + 1.month).beginning_of_month.strftime("%B %Y")
  end

  def budget_bar(title:, size: 5, progress:, total:)
    klass = case
            when progress >= total
              "is-danger"
            when (progress/total) >= 0.666
              "is-warning"
            else
              "is-success"
            end

    "<h3 class='is-size-#{size}'>#{title} - <span class='is-size-#{size+1}'>" \
      "<strong>#{number_to_currency(progress)}</strong> of <strong>#{number_to_currency(total)}</strong>" \
    "</span></h3>" \
    "<progress class='progress #{klass}' value='#{progress}' max='#{total}'></progress>".html_safe
  end
end
