class Api::V1::DepartmentsController < ApplicationController
  include ExceptionHandler
  load_and_authorize_resource
  before_action :set_department, only: [:show, :update, :destroy]

  # GET /api/v1/departments
  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    sort_column = params[:sort_column] || "id"
    sort_order = params[:sort_order] || "desc"

    search_column = params[:search_column]
    search_value = params[:search_value]

    @departments = Department.order("#{sort_column} #{sort_order}").page(page).per(per_page)

    if search_column.present? && search_value.present?
      @departments = @departments.where("lower(#{search_column}) LIKE ?", "%#{search_value.downcase}%")
    end

    total_record = @departments.total_count
    total_page = @departments.total_pages

    meta = {
      total_record: total_record,
      current_page: @departments.current_page,
      total_page: total_page,
      per_page: per_page.to_i
    }

    departments_serialized = ActiveModelSerializers::SerializableResource.new(@departments, each_serializer: DepartmentSerializer)
    serialized_data = departments_serialized.as_json

    render json: { data: departments_serialized, meta: meta }
  end

  # GET /api/v1/departments/:id
  def show
    render json: @department
  end

  # POST /api/v1/departments
  def create
    @department = Department.new(department_params)

    if @department.save
      render json: @department, status: :created
    else
      render json: @department.errors, status: :unprocessable_entity
    end
  end

  # PUT /api/v1/departments/:id
  def update
    if @department.update(department_params)
      render json: @department
    else
      render json: @department.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/departments/:id
  def destroy
    @department.destroy
    head :no_content
  end

  private

  def set_department
    @department = Department.find(params[:id])
  end

  def department_params
    params.require(:department).permit(:name, :description, :organization_id)
  end
end
