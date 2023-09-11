class Api::V1::AttendanceRequestsController < ApplicationController
    before_action :set_attendance_request, only: [:show, :update, :destroy, :approve, :reject]
  
    # GET /api/v1/attendance_requests
    def index
        @attendance_requests = AttendanceRequest.includes(:requested_by, :approved_by, :attendance_status).all
        render json: @attendance_requests.as_json(include: { 
        requested_by: { only: [:id, :email] }, 
        approved_by: { only: [:id, :email] },  
        attendance_status: { only: [:id, :name, :code] }
        }, except: [:requested_by_id, :approved_by_id])
    end
  
    # GET /api/v1/attendance_requests/1
    def show
      render json: @attendance_request.as_json(include: {
        requested_by: { only: [:id, :email] },
        approved_by: { only: [:id, :email] },
        attendance_status: { only: [:id, :name, :code ] }
      }, except: [:requested_by_id, :approved_by_id ])
    end
  
    # POST /api/v1/attendance_requests
    def create
      @attendance_request = AttendanceRequest.new(attendance_request_params)
      @attendance_request.attendance_status = AttendanceStatus.find_by(code:'P')

      if @attendance_request.save
        render json: @attendance_request, status: :created
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
      if @attendance_request.update(attendance_status_id: AttendanceStatus.find_by(code: 'A').id, approved_by_id: params[:approved_by_id])
        render json: { message: 'Attendance request approved successfully', data:  @attendance_request.as_json(include: {
          requested_by: { only: [:id, :email] },
          approved_by: { only: [:id, :email] },
          attendance_status: { only: [:id, :name, :code ] }
        }, except: [:requested_by_id, :approved_by_id, :attendance_status_id ]) }
      else
        render json: { error: 'Unable to approve attendance request' }, status: :unprocessable_entity
      end
    end

    # POST /api/v1/attendance_requests/:id/reject
    def reject
      if @attendance_request.update(attendance_status_id: AttendanceStatus.find_by(code: 'R').id)
        render json: { message: 'Attendance request rejected successfully', data:  @attendance_request.as_json(include: {
          requested_by: { only: [:id, :email] },
          approved_by: { only: [:id, :email] },
          attendance_status: { only: [:id, :name, :code ] }
        }, except: [:requested_by_id, :approved_by_id, :attendance_status_id ]) }
      else
        render json: { error: 'Unable to reject attendance request' }, status: :unprocessable_entity
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
      params.require(:attendance_request).permit(:requested_by_id, :approved_by_id, :notes, :requested_at, :live_location, :selfie_image)
    end
  end
  