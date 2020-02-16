module ApplicationHelper
  def format_time_of_day(s)
    s ||= 0
    t = Time.now.beginning_of_day + s.seconds
    t.strftime('%k:%M')
  end
end
