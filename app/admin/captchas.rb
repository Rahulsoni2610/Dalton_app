ActiveAdmin.register Captcha do
  actions :index, :edit, :show, :destroy, :update

  # Permit the attributes for assignment
  permit_params :captcha_text, :user_input, :is_correct, :user_id

  # Customize the index page
  index do
    selectable_column
    id_column
    column :captcha_text
    column :user_input
    column :is_correct
    column "User Name" do |captcha|
      link_to captcha.user.username, admin_user_path(captcha.user)
    end
    column :created_at
    column :updated_at
    actions
  end

  # Customize the show page
  show do
    attributes_table do
      row :id
      row "User Name" do |captcha|
        link_to captcha.user.username, admin_user_path(captcha.user)
      end
      row :captcha_text
      row :user_input
      row :is_correct
      row :created_at
      row :updated_at
    end
  end

  # Customize the edit form
  form do |f|
    f.inputs 'Captcha Details' do
      f.input :user_id, as: :select, collection: User.pluck(:username, :id) # Adjust as needed
      f.input :captcha_text
      f.input :user_input
      f.input :is_correct
    end
    f.actions
  end
end
