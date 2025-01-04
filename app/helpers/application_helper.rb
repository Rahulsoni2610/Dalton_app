module ApplicationHelper
  def flash_class(level)
    case level.to_sym
    when :notice
      "flex items-center p-4 mb-4 text-blue-800 rounded-lg bg-blue-50"
    when :alert
      "flex items-center p-4 mb-4 text-red-800 rounded-lg bg-red-50"
    when :success
      "flex items-center p-4 mb-4 text-green-800 rounded-lg bg-green-50"
    when :warning
      "flex items-center p-4 mb-4 text-yellow-800 rounded-lg bg-yellow-50"
    else
      "flex items-center p-4 mb-4 text-gray-800 rounded-lg bg-gray-50"
    end
  end
end
