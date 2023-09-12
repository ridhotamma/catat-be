class Api::V1::UsersController < ApplicationController
    include ExceptionHandler
    before_action :set_user, only: [:show, :update, :destroy]

    def index
      page = params[:page] || 1
      per_page = params[:per_page] || 10
    
      @users = User.includes(:organization, :department, :role).page(page).per(per_page)
    
      total_record = @users.total_count
      total_page = @users.total_pages
    
      meta = {
        total_record: total_record,
        current_page: @users.current_page,
        total_page: total_page,
        per_page: per_page.to_i
      }
    
      render json: { data: @users.as_json(
        include: {
          organization: { only: :name },
          department: { only: :name },
          role: { only: :name }
        },
        except: [:password_digest, :created_at, :updated_at]
      ), meta: meta }
    end    

    def show
      render json: @user, serializer: UserSerializer
    end

    def create
      user = User.new(user_params)
      if user.save
        render json: { message: 'User created successfully' }, status: :created
      else
        render json: { error: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    end
    
    def update
      if @user.update(update_allowed_params)
        render json: { message: 'User updated successfully' }
      else
        render json: { error: @user.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    end

    def login
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        token = generate_token(user)
        render json: { message: 'Login successful', user: UserSerializer.new(user), token: token }
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end
    
    def profile
      render json: @current_user
    end

    def update_profile
      if @current_user.update(self_update_allowed_params)
        render json: { message: 'User updated successfully' }
      else
        render json: { error: @current_user.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
      head :no_content
    end

    private

    def user_params
      user_params = {
        first_name: params[:first_name],
        last_name: params[:last_name],
        email: params[:email],
        password: params[:password],
        profile_picture: params[:profile_picture],
        organization_id: params[:organization_id],
        department_id: params[:department_id]
      }
    
      user_params[:organization_id] = params[:organization_id] if params[:organization_id].present?
      user_params[:department_id] = params[:department_id] if params[:department_id].present?
      user_params[:role_id] = @current_user.role.code == 'ADMIN' ? params[:role_id] : Role.find_by(code: 'STAFF').id
    
      user_params
    end

    def generate_token(user)
      JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def update_allowed_params
      params.require(:user).permit(:role_id, :profile_picture, :department_id, :password)
    end

    def self_update_allowed_params
      params.require(:user).permit(:profile_picture, :department_id, :password)
    end
  end
  