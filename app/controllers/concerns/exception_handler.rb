module ExceptionHandler
    extend ActiveSupport::Concern
    
    load_and_authorize_resource

    included do
      rescue_from ActiveRecord::RecordNotFound do |e|
        json_response({ error: e.message }, :not_found)
      end
  
      rescue_from ActiveRecord::RecordInvalid do |e|
        json_response({ error: e.message }, :unprocessable_entity)
      end
  
      rescue_from ActionController::RoutingError do |e|
        json_response({ error: 'Route not found' }, :not_found)
      end

      rescue_from ActionController::BadRequest do |e|
        json_response({ error: 'Bad request' }, :bad_request)
      end

      rescue_from CanCan::AccessDenied do |exception|
        render json: { error: 'Access denied', message: exception.message }, status: :forbidden
      end
    end
    
    private
  
    def json_response(message, status = :ok)
      render json: message, status: status
    end
  end
  