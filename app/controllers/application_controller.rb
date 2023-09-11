class ApplicationController < ActionController::API
    before_action :authenticate_user

    private

    def authenticate_user
        token = request.headers['Authorization']&.sub(/^Bearer /, '')
        @current_user = token ? User.find_by(id: JwtService.decode(token)['user_id']) : nil
    end
end
