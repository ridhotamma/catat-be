class Api::V1::UsersController < ApplicationController
  include ExceptionHandler
  load_and_authorize_resource
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :set_changing_password, only: [:change_password]

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    sort_column = params[:sort_column] || "id"
    sort_order = params[:sort_order] || "desc"

    search_column = params[:search_column]
    search_value = params[:search_value]

    @users = User.order("#{sort_column} #{sort_order}").page(page).per(per_page)

    if search_column.present? && search_value.present?
      @users = @users.where("lower(#{search_column}) LIKE ?", "%#{search_value.downcase}%")
    end

    total_record = @users.total_count
    total_page = @users.total_pages

    meta = {
      total_record: total_record,
      current_page: @users.current_page,
      total_page: total_page,
      per_page: per_page.to_i
    }

    user_serialized = ActiveModelSerializers::SerializableResource.new(@users, each_serializer: UserSerializer)
    serialized_data = user_serialized.as_json

    render json: { data: user_serialized, meta: meta }
  end

  def show
    render json: @user, serializer: UserSerializer
  end

  def create
    user = User.new(user_params)

    unless user.profile_picture.present?
      user.profile_picture.attach(io: File.open(Rails.root.join("assets", "avatar-default.jpeg")),
                                  filename: "default_profile_picture.jpg",
                                  content_type: "image/jpeg")
    end

    if user.save
      render json: { data: @user, message: "User created successfully" }, status: :created
    else
      render json: { error: user.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(update_allowed_params)
      render json: { data: UserSerializer.new(@user), message: "User updated successfully" }
    else
      render json: { error: @user.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def profile
    render json: @current_user
  end

  def update_profile
    if @current_user.update(self_update_allowed_params)
      render json: { data: UserSerializer.new(@current_user), message: "User updated successfully" }
    else
      render json: { error: @current_user.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  def change_password
    old_password = params[:old_password]
    new_password = params[:new_password]

    if @user.authenticate(old_password)
      if @user.update(password: new_password)
        render json: { message: "Password successfully changed" }, status: :ok
      else
        render json: { error: "Failed to update password" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Wrong Password" }, status: :unauthorized
    end
  end

  private

  def user_params
    user_params = {
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      password: params[:password],
      profile_picture: params[:profile_picture]
    }

    user_params[:organization_id] = params[:organization_id] if params[:organization_id].present?
    user_params[:department_id] = params[:department_id] if params[:department_id].present?
    user_params[:role_id] = @current_user.role.code == "ADMIN" ? params[:role_id] : Role.find_by(code: "STAFF").id

    user_params
  end

  def set_user
    @user = User.find(params[:id])
  end

  def update_allowed_params
    user_params = {}

    user_params[:first_name] = params[:first_name] if params[:first_name].present?
    user_params[:last_name] = params[:last_name] if params[:last_name].present?
    user_params[:email] = params[:email] if params[:email].present?
    user_params[:profile_picture] = params[:profile_picture] if params[:profile_picture].present?
    user_params[:role_id] = params[:role_id] if params[:role_id].present?
    user_params[:organization_id] = params[:organization_id] if params[:organization_id].present?
    user_params[:department_id] = params[:department_id] if params[:department_id].present?

    user_params
  end

  def self_update_allowed_params
    user_params = {
      first_name: params[:first_name],
      last_name: params[:last_name],
      profile_picture: params[:profile_picture]
    }

    return user_params
  end

  def set_changing_password
    @user = @current_user
    @user.changing_password = true
  end
end
