class ApplicationController < ActionController::Base
  before_action :check_force_logout

  def check_force_logout
    if current_user && current_user.force_logout?
      current_user.update_column(:force_logout, false)
      sign_out(current_user)
    end
  end
end
