class ApplicationController < ActionController::API
  before_action :set_current_user, except: [:login]
  before_action :authenticate_user, except: [:login]

  private

  def set_current_user
    token = request.headers["Authorization"]&.sub(/^Bearer /, "")
    if token
      begin
        @current_user = User.find_by(id: JwtService.decode(token)["user_id"])
      rescue JWT::DecodeError => e
        handle_invalid_token(e.message)
        return
      end

      unless @current_user
        handle_invalid_token("User not found")
        return
      end
    end
  end

  def authenticate_user
    unless @current_user
      handle_invalid_token("Token not provided")
    end
  end

  def current_ability
    @current_ability ||= Ability.new(@current_user)
  end

  def handle_invalid_token(message)
    render json: { error: "Invalid token", details: message }, status: :unauthorized
  end
end
