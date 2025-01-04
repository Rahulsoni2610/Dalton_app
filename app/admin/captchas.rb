ActiveAdmin.register Captcha do
  actions :all, except: [:new]

  # config.per_page = [10, 12, 15, 200]
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :captcha_text, :user_input, :is_correct, :user_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:captcha_text, :user_input, :is_correct, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
