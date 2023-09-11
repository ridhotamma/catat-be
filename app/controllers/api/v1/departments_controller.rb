class Api::V1::DepartmentsController < ApplicationController
    before_action :set_department, only: [:show, :update, :destroy]
    
    # GET /api/v1/departments
    def index
      @departments = Department.all
      render json: @departments
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
  