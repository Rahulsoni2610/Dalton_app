ActiveAdmin.register User do
  permit_params :email, :username, :password, :is_active


  member_action :logout_user, method: :post do
    user = User.find(params[:id])
    user.update_column(:force_logout, true)
    redirect_to admin_users_path, notice: "User #{user.username} has been logged out."
  end


  form do |f|
    f.inputs "User Details" do
      f.input :email, required: true
      f.input :username, required: true
      if f.object.new_record?
        f.input :password, required: true
      else
        f.input :password, required: false
      end
      f.input :is_active, as: :boolean, label: "Active"
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :email
    column :username
    column :is_active
    column :current_sign_in_at
    column :last_sign_in_at
    column 'Total Captchas' do |user|
      link_to user.captchas.count, admin_captchas_path(q: { user_id_eq: user.id })
    end
    column 'Accuracy (%)' do |user|
      accuracy = user.captcha_accuracy
      accuracy.is_a?(String) ? accuracy : "#{accuracy}%"
    end
    actions defaults: true do |user|
      item "Logout", logout_user_admin_user_path(user), method: :post, class: "member_link", data: { confirm: "Are you sure you want to logout this user?" }
    end
  end


  show do
    attributes_table do
      row :id
      row :email
      row :username
      row :is_active

      row 'Total Captchas' do |user|
        link_to user.captchas.count, admin_captchas_path(q: { user_id_eq: user.id })
      end

      row 'Captchas Accuracy (%)' do |user|
        user.captcha_accuracy
      end

      row :created_at
      row :updated_at
    end
  end


  csv do
    column :id
    column :email
    column :username
    column :is_active
    column :current_sign_in_at
    column :last_sign_in_at
    column 'Total Captchas' do |user|
      user.captchas.count
    end
    column 'Accuracy (%)' do |user|
      user.captcha_accuracy
    end
  end

  filter :email
  filter :username
  filter :is_active
  filter :created_at

  controller do

    def create
      entered_password = params[:user][:password]

      @user = User.new(permitted_params[:user])

      if @user.save
        UserMailer.send_credentials(@user, entered_password).deliver_later

        redirect_to admin_users_path, notice: 'User created successfully. Credentials have been sent to their email.'
      else
        render :new
      end
    end

    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].extract!(:password, :password_confirmation)
      end
      super
    end

    rescue_from ActionController::InvalidAuthenticityToken, with: :handle_invalid_authenticity_token

    private

    def handle_invalid_authenticity_token
      redirect_to new_admin_user_session_path, alert: "Your session has expired. Please log in again."
    end
  end
end
