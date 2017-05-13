class PrioritiesController < ApplicationController
  load_and_authorize_resource
  before_action :set_priority, only: [:show, :edit, :update, :destroy]

  # GET /priorities
  # GET /priorities.json
  def index
    @priorities = Priority.all
  end

  # GET /priorities/1
  # GET /priorities/1.json
  def show
  end

  # GET /priorities/new
  def new
    @priority = Priority.new
  end

  # GET /priorities/1/edit
  def edit
  end

  # POST /priorities
  # POST /priorities.json
  def create
    @priority = Priority.new(priority_params)

    respond_to do |format|
      if @priority.save
        format.html { redirect_to @priority, notice: t('priority.successfully-created') }
        format.json { render :show, status: :created, location: @priority }
      else
        format.html { render :new }
        format.json { render json: @priority.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /priorities/1
  # PATCH/PUT /priorities/1.json
  def update
    respond_to do |format|
      if @priority.update(priority_params)
        format.html { redirect_to @priority, notice: t('priority.successfully-updated') }
        format.json { render :show, status: :ok, location: @priority }
      else
        format.html { render :edit }
        format.json { render json: @priority.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /priorities/1
  # DELETE /priorities/1.json
  def destroy
    message = ""
    message_type = "notice"
    if @priority.destroy
      message = t('priority.successfully-destroyed')
    else
      message_type = "alert"
      unless @priority.errors.full_messages.blank?
        @priority.errors.full_messages.each do | error_message |
          message += error_message +". "
        end
      else
        message = t('priority.not-destroyed')
      end
    end
    respond_to do |format|
      if message_type == "alert"
        format.html { redirect_to priorities_url, alert: message }
        format.json { head :no_content }
      else
        format.html { redirect_to priorities_url, notice: message }
        format.json { head :no_content }
      end
    end
  end


  private
    def set_priority
      @priority = Priority.find(params[:id])
    end

    def priority_params
      params.require(:priority).permit(:name, :description)
    end
end
