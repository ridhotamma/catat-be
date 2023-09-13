class Api::V1::AttendanceRequestsController < ApplicationController
    include ExceptionHandler
    load_and_authorize_resource

    before_action :set_attendance_request, only: [:show, :update, :destroy, :approve, :reject, :cancel]

    # GET /api/v1/attendance_requests
    def index
      page = params[:page] || 1
      per_page = params[:per_page] || 10

      filtered_requests = AttendanceRequest.where(requested_by: @current_user)

      month = params[:month]
      year = params[:year]
      
      if month.present? && year.present?
        start_date = Date.new(year.to_i, month.to_i, 1).beginning_of_month
        end_date = start_date.end_of_month
      else
        start_date = Date.current.beginning_of_month
        end_date = Date.current.end_of_month
      end

      @attendance_requests = filtered_requests.where(clock_in: start_date..end_date).page(page).per(per_page)
    
      total_record = @attendance_requests.total_count
      total_page = @attendance_requests.total_pages
    
      meta = {
        total_record: total_record,
        current_page: @attendance_requests.current_page,
        total_page: total_page,
        per_page: per_page.to_i
      }
      
      attendance_request_serialized = ActiveModelSerializers::SerializableResource.new(@attendance_requests, each_serializer: AttendanceRequestSerializer)
      serialized_data = attendance_request_serialized.as_json

      render json: {data: attendance_request_serialized, meta: meta }
    end
    
   # GET /api/v1/attendance_requests/all
    def all_requests
      page = params[:page] || 1
      per_page = params[:per_page] || 10

      month = params[:month]
      year = params[:year]

      if month.present? && year.present?
        start_date = Date.new(year.to_i, month.to_i, 1).beginning_of_month
        end_date = start_date.end_of_month
      else
        start_date = Date.current.beginning_of_month
        end_date = Date.current.end_of_month
      end
      
      @attendance_requests = AttendanceRequest.where(clock_in: start_date..end_date).page(page).per(per_page)
      
      total_record = @attendance_requests.total_count
      total_page = @attendance_requests.total_pages

      meta = {
        total_record: total_record,
        current_page: @attendance_requests.current_page,
        total_page: total_page,
        per_page: per_page.to_i
      }
      
      attendance_request_serialized = ActiveModelSerializers::SerializableResource.new(@attendance_requests, each_serializer: AttendanceRequestSerializer)
      serialized_data = attendance_request_serialized.as_json

      render json: {data: attendance_request_serialized, meta: meta }
    end

    # GET /api/v1/attendance_requests/1
    def show
      render json: @attendance_request
    end
  
    # POST /api/v1/attendance_requests
    def clock_in
      existing_request = AttendanceRequest.where(requested_by: @current_user, clock_in: Date.today.beginning_of_day..Date.today.end_of_day).first

      if existing_request
        render json: { error: "A clock-in request for today already exists." }, status: :unprocessable_entity
        return
      end

      @attendance_request = AttendanceRequest.new(attendance_request_params)
      @attendance_request.attendance_status = AttendanceStatus.find_by(code:'P')
      @attendance_request.requested_by = @current_user
      @attendance_request.clock_in = Time.now
      
      if @attendance_request.save
        render json: @attendance_request, serializer: AttendanceRequestSerializer, status: :created
      else
        render json: @attendance_request.errors, status: :unprocessable_entity
      end
    end
    
    # POST /api/v1/attendance_requests
    def clock_out
      existing_request = AttendanceRequest.where(requested_by: @current_user, clock_out: Date.today.beginning_of_day..Date.today.end_of_day).first

      if existing_request
        render json: { error: "A clock-out request for today already exists." }, status: :unprocessable_entity
        return
      end

      @attendance_request = AttendanceRequest.where(requested_by: @current_user, clock_in: Date.today.beginning_of_day..Date.today.end_of_day).last

      if @attendance_request.update(clock_out:Time.now)
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
