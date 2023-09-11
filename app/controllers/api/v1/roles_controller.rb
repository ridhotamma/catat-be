class Api::V1::RolesController < ApplicationController
    before_action :set_role, only: [:show, :update, :destroy]
  
    # GET /api/v1/roles
    def index
      @roles = Role.all
      render json: @roles
    end
  
    # GET /api/v1/roles/:id
    def show
      render json: @role
    end
  
    # POST /api/v1/roles
    def create
      @role = Role.new(role_params)
  
      if @role.save
        render json: @role, status: :created
      else
        render json: @role.errors, status: :unprocessable_entity
      end
    end
  
    # PUT /api/v1/roles/:id
    def update
      if @role.update(role_params)
        render json: @role
      else
        render json: @role.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /api/v1/roles/:id
    def destroy
      @role.destroy
      head :no_content
    end
  
    private
  
    def set_role
      @role = Role.find(params[:id])
    end
  
    def role_params
      params.require(:role).permit(:name, :code)
    end
  end
  