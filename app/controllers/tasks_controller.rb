class TasksController < ApplicationController
  load_and_authorize_resource
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    #TODO Move this search
    @tasks = Task.all
    @tasks = @tasks.where(tasks:{id: params[:search_id]}) if !params[:search_id].blank?
    @tasks = @tasks.where(tasks:{reported_by: params[:search_reported_by]}) if !params[:search_reported_by].blank?
    @tasks = @tasks.where(tasks:{assigned_to: params[:search_assigned_to]}) if !params[:search_assigned_to].blank?
    @tasks = @tasks.where(tasks:{priority_id: params[:search_priority_id]}) if !params[:search_priority_id].blank?
    @tasks = @tasks.where(tasks:{status_id: params[:search_status_id]}) if !params[:search_status_id].blank?
    @tasks = @tasks.where(tasks:{vertical_id: params[:search_vertical_id]}) if !params[:search_vertical_id].blank?
    @tasks = @tasks.where(tasks:{request_type_id: params[:search_request_type_id]}) if !params[:search_request_type_id].blank?
    @tasks = @tasks.where("title ILIKE ?", "%#{params[:search_title]}%") if !params[:search_title].blank?
    @tasks = @tasks.where("description ILIKE ?", "%#{params[:search_description]}%") if !params[:search_description].blank?

    order_options = {
      newest: "created_at DESC",
      oldest: "created_at ASC",
    }

    @tasks = @tasks.order(order_options[params[:order_by].to_sym]) if !params[:order_by].blank?
    @tasks = @tasks.paginate(page: params[:page], :per_page => 8)

  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @comments = Comment.where(task_id: @task.id).order(id: :desc)
    @comment = Comment.new
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create

    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        @task.send_slack
        format.html { redirect_to @task, notice: t('task.successfully-created') }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update

    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: t('task.successfully-updated') }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: t('task.successfully-destroyed') }
      format.json { head :no_content }
    end
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params

      params.require(:task).permit(:title,
                                   :description,
                                   :reported_by_id,
                                   :assigned_to_id,
                                   :status_id,
                                   :request_type_id,
                                   :member_facing,
                                   :vertical_id,
                                   :title,
                                   :link,
                                   :required_by,
                                   :priority_id,
                                   attachments_attributes:[:doc]
                                   )
    end
end
