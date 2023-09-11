module ExceptionHandler
    extend ActiveSupport::Concern
  
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
    end
  
    private
  
    def json_response(message, status = :ok)
      render json: message, status: status
    end
  end
  