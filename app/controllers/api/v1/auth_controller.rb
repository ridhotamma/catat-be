class Api::V1::AuthController < ApplicationController
  # api/v1/auth/login
  def login
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      token = generate_token(user)
      render json: { message: "Login successful", user: UserSerializer.new(user), token: token }
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  private

  def generate_token(user)
    expiration_time = 12.hour.from_now.to_i
    payload = { user_id: user.id, exp: expiration_time }
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end
end
