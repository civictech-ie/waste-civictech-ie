module ApplicationHelper
  def format_time_of_day(s)
    t = Time.now.beginning_of_day + s.seconds
    t.strftime('%k:%M')
  end
end
