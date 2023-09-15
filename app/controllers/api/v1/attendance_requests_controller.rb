class Api::V1::AttendanceRequestsController < ApplicationController
    include ExceptionHandler
    load_and_authorize_resource

    before_action :set_attendance_request, only: [:show, :update, :destroy, :approve, :reject, :cancel]
    before_action :set_attendance_setting, only: [:clock_in, :clock_out]

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
      @attendance_request = AttendanceRequest.new(attendance_request_params)
      @attendance_request.attendance_status = AttendanceStatus.find_by(code:'P')
      @attendance_request.requested_by = @current_user
      @attendance_request.clock_in = Time.now

      existing_request = AttendanceRequest.where(requested_by: @current_user, clock_in: Date.today.beginning_of_day..Date.today.end_of_day).first

      # if one request per day is enabled
      if existing_request && @attendance_setting.enable_one_request_per_day
        render json: { error: "A clock-in request for today already exists." }, status: :unprocessable_entity
        return
      end
      
      # if one live location is enabled
      if @attendance_setting.enable_live_location && !@attendance_request.within_organization_radius?
        render json: { error: "Your Location is not within the organization place.", info: @attendance_request.self_and_organization_location }, status: :unprocessable_entity
        return
      end

      if @attendance_request.save
        render json: { message: 'Clock in Request Success', data: AttendanceRequestSerializer.new(@attendance_request) }, status: :created
      else
        render json: @attendance_request.errors, status: :unprocessable_entity
      end
    end
    
    # POST /api/v1/attendance_requests
    def clock_out
      existing_request = AttendanceRequest.where(requested_by: @current_user, clock_out: Date.today.beginning_of_day..Date.today.end_of_day).first

      if existing_request && @attendance_setting[:enable_one_request_per_day]
        render json: { error: "A clock-out request for today already exists." }, status: :unprocessable_entity
        return
      end

      @attendance_request = AttendanceRequest.where(requested_by: @current_user, clock_in: Date.today.beginning_of_day..Date.today.end_of_day).last

      if @attendance_request.update(clock_out:Time.now)
        render json: { message: 'Clock out Request Success', data: AttendanceRequestSerializer.new(@attendance_request)}, status: :created
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
    
    def set_attendance_setting
      @attendance_setting = AttendanceSetting.find_by(organization: @current_user.organization)
    end

    def set_attendance_request
      @attendance_request = AttendanceRequest.find(params[:id])
    end
  
    def attendance_request_params
      params.permit(:notes, :latitude, :longitude, :selfie_image)
    end
  end
