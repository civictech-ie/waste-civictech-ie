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
end
