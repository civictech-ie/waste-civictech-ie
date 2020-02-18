module StreetsHelper
  def format_presentation_method(method_str)
    case method_str
    when 'bin'
      'wheelie bin'
    when 'mixed'
      'paid-for bin bags'
    when 'bag'
      'wheelie bins and paid-for bin bags'
    end
  end

  def format_days(day_ary)
    if day_ary.uniq.size == 7
      'any day of the week'
    else
      day_ary.map(&:capitalize).to_sentence
    end
  end
end
