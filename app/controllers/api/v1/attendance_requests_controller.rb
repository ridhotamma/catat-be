class Api::V1::AttendanceRequestsController < ApplicationController
    include ExceptionHandler
    load_and_authorize_resource

    before_action :set_attendance_request, only: [:show, :update, :destroy, :approve, :reject, :cancel]

    # GET /api/v1/attendance_requests
    def index
        @attendance_requests = AttendanceRequest.includes(:requested_by, :approved_by, :attendance_status).all
        render json: @attendance_requests
    end
  
    # GET /api/v1/attendance_requests/1
    def show
      render json: @attendance_request
    end
  
    # POST /api/v1/attendance_requests
    def create
      @attendance_request = AttendanceRequest.new(attendance_request_params)
      @attendance_request.attendance_status = AttendanceStatus.find_by(code:'P')
      @attendance_request.requested_by = @current_user
      @attendance_request.requested_at = Time.now
      
      if @attendance_request.save
        render json: @attendance_request, serializer: AttendanceRequestSerializer, status: :created
      else
        render json: @attendance_request.errors, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /api/v1/attendance_requests/1
    def update
      if @attendance_request.update(attendance_request_params)
        render json: @attendance_request
      else
        render json: @attendance_request.errors, status: :unprocessable_entity
      end
    end
    
    # POST /api/v1/attendance_requests/:id/approve
    def approve
      if @attendance_request.update(attendance_status_id: AttendanceStatus.find_by(code: 'A').id, approved_by: @current_user)
        render json: @attendance_request
      else
        render json: { error: 'Unable to approve attendance request' }, status: :unprocessable_entity
      end
    end

    # POST /api/v1/attendance_requests/:id/reject
    def reject
      if @attendance_request.update(attendance_status_id: AttendanceStatus.find_by(code: 'R').id, approved_by: @current_user)
        render json: @attendance_request
      else
        render json: { error: 'Unable to reject attendance request' }, status: :unprocessable_entity
      end
    end

    # POST /api/v1/attendance_requests/:id/cancel
    def cancel
      if @attendance_request.update(attendance_status_id: AttendanceStatus.find_by(code: 'C').id)
        render json: @attendance_request
      else
        render json: { error: 'Unable to cancel attendance request' }, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/attendance_requests/1
    def destroy
      @attendance_request.destroy
      head :no_content
    end
  
    private
  
    def set_attendance_request
      @attendance_request = AttendanceRequest.find(params[:id])
    end
  
    def attendance_request_params
      params.require(:attendance_request).permit(:notes, :live_location, :selfie_image)
    end
  end
