class ApplicationController < ActionController::API
    before_action :authenticate_user

    private

    def authenticate_user
        token = request.headers['Authorization']&.sub(/^Bearer /, '')
        @current_user = token ? User.find_by(id: JwtService.decode(token)['user_id']) : nil
    end
    
    def current_ability
        @current_ability ||= Ability.new(@current_user)
    end
end
