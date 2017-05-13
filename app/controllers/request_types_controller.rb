class RequestTypesController < ApplicationController
  load_and_authorize_resource
  before_action :set_request_type, only: [:show, :edit, :update, :destroy]

  # GET /request_types
  # GET /request_types.json
  def index
    @request_types = RequestType.all
  end

  # GET /request_types/1
  # GET /request_types/1.json
  def show
  end

  # GET /request_types/new
  def new
    @request_type = RequestType.new
  end

  # GET /request_types/1/edit
  def edit
  end

  # POST /request_types
  # POST /request_types.json
  def create
    @request_type = RequestType.new(request_type_params)

    respond_to do |format|
      if @request_type.save
        format.html { redirect_to @request_type, notice: t('request_type.successfully-created') }
        format.json { render :show, status: :created, location: @request_type }
      else
        format.html { render :new }
        format.json { render json: @request_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /request_types/1
  # PATCH/PUT /request_types/1.json
  def update
    respond_to do |format|
      if @request_type.update(request_type_params)
        format.html { redirect_to @request_type, notice: t('request_type.successfully-updated') }
        format.json { render :show, status: :ok, location: @request_type }
      else
        format.html { render :edit }
        format.json { render json: @request_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /request_types/1
  # DELETE /request_types/1.json
  def destroy
    message = ""
    message_type = "notice"
    if @request_type.destroy
      message = t('request_type.successfully-destroyed')
    else
      message_type = "alert"
      unless @request_type.errors.full_messages.blank?
        @request_type.errors.full_messages.each do | error_message |
          message += error_message +". "
        end
      else
        message = t('request_type.not-destroyed')
      end
    end
    respond_to do |format|
      if message_type == "alert"
        format.html { redirect_to request_types_url, alert: message }
        format.json { head :no_content }
      else
        format.html { redirect_to request_types_url, notice: message }
        format.json { head :no_content }
      end
    end
  end

  private
    def set_request_type
      @request_type = RequestType.find(params[:id])
    end

    def request_type_params
      params.require(:request_type).permit(:name, :description)
    end
end
