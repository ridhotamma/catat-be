class Api::V1::OrganizationsController < ApplicationController
  include ExceptionHandler
  load_and_authorize_resource
  before_action :set_organization, only: [:show, :update, :destroy, :attendance_settings]

  # GET /api/v1/organizations
  def index
    @organizations = Organization.all
    render json: @organizations
  end

  # GET /api/v1/organizations/:id
  def show
    render json: @organization
  end

  # POST /api/v1/organizations
  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      render json: @organization, status: :created
    else
      render json: @organization.errors, status: :unprocessable_entity
    end
  end

  # PUT /api/v1/organizations/:id
  def update
    if @organization.update(organization_params)
      render json: @organization
    else
      render json: @organization.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/organizations/:id
  def destroy
    @organization.destroy
    head :no_content
  end

  # GET /api/v1/organizations/attendance_settings
  def attendance_settings
    if @current_user.organization.attendance_setting
      render json: @current_user.organization.attendance_setting
    else
      render json: { message: "Attendance setting not found for this organization" }, status: :not_found
    end
  end

  # PUT /api/v1/organizations/attendance_settings
  def update_attendance_settings
    if @current_user.organization.attendance_setting.update(attendance_setting_params)
      render json: @current_user.organization.attendance_setting
    else
      render json: { message: "Attendance setting not found for this organization" }, status: :not_found
    end
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name, :logo, :description)
  end

  def attendance_setting_params
    params.permit(:enable_live_location, :enable_take_selfie, :enable_auto_approval_attendance, :enable_one_request_per_day)
  end
end
