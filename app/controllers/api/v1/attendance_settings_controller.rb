class Api::V1::AttendanceSettingsController < ApplicationController
  include ExceptionHandler
  load_and_authorize_resource
  before_action :set_attendance_setting, only: [:show, :update, :destroy]

  def index
    @attendance_settings = AttendanceSetting.all
    render json: @attendance_settings
  end

  def show
    render json: { data: @attendance_setting.as_json(except: ['created_at', 'updated_at']) }
  end

  def create
    @attendance_setting = AttendanceSetting.new(attendance_setting_params)

    if @attendance_setting.save
      render json: @attendance_setting, status: :created
    else
      render json: @attendance_setting.errors, status: :unprocessable_entity
    end
  end

  def update
    if @attendance_setting.update(attendance_setting_params)
      render json: @attendance_setting
    else
      render json: @attendance_setting.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @attendance_setting.destroy
    head :no_content
  end

  private

  def set_attendance_setting
    @attendance_setting = AttendanceSetting.find(params[:id])
  end

  def attendance_setting_params
    params.require(:attendance_setting).permit(:enable_live_location, :enable_take_selfie, :enable_auto_approval_attendance, :organization_id)
  end
end
