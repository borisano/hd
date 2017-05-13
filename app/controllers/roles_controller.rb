class RolesController < ApplicationController
  load_and_authorize_resource
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  # GET /roles
  # GET /roles.json
  def index
    @roles = Role.all
  end

  # GET /roles/1
  # GET /roles/1.json
  def show
  end

  # GET /roles/new
  def new
    @role = Role.new
  end

  # GET /roles/1/edit
  def edit
  end

  # POST /roles
  # POST /roles.json
  def create
    @role = Role.new(role_params)

    respond_to do |format|
      if @role.save
        format.html { redirect_to @role, notice: t('role.successfully-created') }
        format.json { render :show, status: :created, location: @role }
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1
  # PATCH/PUT /roles/1.json
  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to @role, notice: t('role.successfully-updated') }
        format.json { render :show, status: :ok, location: @role }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    message = ""
    message_type = "notice"
    if @role.destroy
      message = t('role.successfully-destroyed')
    else
      message_type = "alert"
      unless @role.errors.full_messages.blank?
        @role.errors.full_messages.each do | error_message |
          message += error_message +". "
        end
      else
        message = t('role.not-destroyed')
      end
    end
    respond_to do |format|
      if message_type == "alert"
        format.html { redirect_to roles_url, alert: message }
        format.json { head :no_content }
      else
        format.html { redirect_to roles_url, notice: message }
        format.json { head :no_content }
      end
    end
  end

  private

    def set_role
      @role = Role.find(params[:id])
    end

    def role_params
      params.require(:role).permit(:name, :description)
    end
end
