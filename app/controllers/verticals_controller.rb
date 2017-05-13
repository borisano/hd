class VerticalsController < ApplicationController
  load_and_authorize_resource
  before_action :set_vertical, only: [:show, :edit, :update, :destroy]

  # GET /verticals
  # GET /verticals.json
  def index
    @verticals = Vertical.all
  end

  # GET /verticals/1
  # GET /verticals/1.json
  def show
  end

  # GET /verticals/new
  def new
    @vertical = Vertical.new
  end

  # GET /verticals/1/edit
  def edit
  end

  # POST /verticals
  # POST /verticals.json
  def create
    @vertical = Vertical.new(vertical_params)
    respond_to do |format|
      if @vertical.save
        format.html { redirect_to @vertical, notice: t('vertical.successfully-created') }
        format.json { render :show, status: :created, location: @vertical }
      else
        format.html { render :new }
        format.json { render json: @vertical.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /verticals/1
  # PATCH/PUT /verticals/1.json
  def update
    respond_to do |format|
      if @vertical.update(vertical_params)
        format.html { redirect_to @vertical, notice: t('vertical.successfully-updated') }
        format.json { render :show, status: :ok, location: @vertical }
      else
        format.html { render :edit }
        format.json { render json: @vertical.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /verticals/1
  # DELETE /verticals/1.json
  def destroy
    message = ""
    message_type = "notice"
    if @vertical.destroy
      message = t('vertical.successfully-destroyed')
    else
      message_type = "alert"
      unless @vertical.errors.full_messages.blank?
        @vertical.errors.full_messages.each do | error_message |
          message += error_message +". "
        end
      else
        message = t('vertical.not-destroyed')
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
    def set_vertical
      @vertical = Vertical.find(params[:id])
    end

    def vertical_params
      params.require(:vertical).permit(:name, :description)
    end
end
