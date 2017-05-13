class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :set_user, only: [:show, :edit, :update, :destroy, :approve]

  def index
    #TODO Should be moved to a helper
    @users = User.all
    @users = @users.where(users:{role_id: params[:search_role]}) if !params[:search_role].blank? && params[:search_role] != 'nil'&& params[:search_role] != 'all'
    @users = @users.where(users:{role_id: nil}) if !params[:search_role].blank? && params[:search_role] == 'nil'
    @users = @users.where(users:{approved: params[:search_approved]}) if !params[:search_approved].blank?
    @users = @users.where("first_name ILIKE ?", "%#{params[:search_first_name]}%") if !params[:search_first_name].blank?
    @users = @users.where("last_name ILIKE ?", "%#{params[:search_last_name]}%") if !params[:search_last_name].blank?
    @users = @users.where("email ILIKE ?", "%#{params[:search_email]}%") if !params[:search_email].blank?
    @users = @users.paginate(:page => params[:page], :per_page => 10)
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
    @direction = "/update_user_no_devise/#{@user.id}"
  end

  def create
    @direction = '/create_user_no_devise'
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: t("user.successfully-created")
    else
      message=""
      unless @user.errors.full_messages.blank?
        @user.errors.full_messages.each do | error_message |
          message += error_message +". "
        end
      end
      redirect_to "/new_user_no_devise", alert: message
    end
  end

  def update
    if @user.update(pw_present(user_params))
      redirect_to @user, notice: t("user.successfully-updated")
    else
      render :edit
    end
  end

  def destroy
    redirect_location = ""
    message_type = "notice"
    message = ""
    if current_user.id == @user.id
      if @user.destroy
        redirect_location = new_user_session_url
        message = t("user.your-account-deleted")
      end
    elsif @user.destroy
      message = t("user.user-account-deleted")
      redirect_location = users_path
    else
      message_type = "alert"
      redirect_location = root_path
      unless @user.errors.full_messages.blank?
        @user.errors.full_messages.each do | error_message |
          message += error_message +". "
        end
      else
        message = t("user.not-destroyed")
      end
    end
    if message_type == "alert"
      redirect_to redirect_location, alert: message
    else
      redirect_to redirect_location, notice: message
    end
  end

  def approve
    notice = t("user.successfully-approved")
    @user.update_attribute(:approved, true)
    redirect_to users_path, notice: notice
  end

  def serve_avatar
    unless @user.avatar_identifier.blank?
      if params[:type]
        if params[:type] == "thumb"
          image_name = "#{params[:type]}_#{@user.avatar_identifier}"
        else
          image_name = @user.avatar_identifier
        end
        image_path = File.join(Rails.root,"dynamic_files",Rails.env, "user", "avatar", @user.id.to_s,image_name)
      end
    else
      image_path = File.join(Rails.root,"public","site_images","no_avatar_image_thumb.png")
    end
    unless send_file( image_path,disposition: 'inline', x_sendfile: true )
      return "some default image" #TODO add default thumb
    end
  end

  def destroy_avatar
    if params[:id]
      if @user.avatar
        @user.remove_avatar = true
        @user.save
        image_path = File.join(Rails.root,"dynamic_files",Rails.env, "user", "avatar", params[:id])
        FileUtils.rmdir(image_path)
      end
    end
   redirect_to(request.env['HTTP_REFERER']) #TODO better redirect
  end

  private

  def pw_present(old_params)
    if old_params[:password].blank? && old_params[:password_confirmation].blank?
      old_params.delete(:password)
      old_params.delete(:password_confirmation)
    end
    old_params
  end

  def set_user
    @user = User.find(params[:id])
    session[:user_id] = @user.id
  end

  def user_params
    params.require(:user).permit( :id,
                                  :avatar,
                                  :first_name,
                                  :last_name,
                                  :password,
                                  :password_confirmation,
                                  :email,
                                  :role_id,
                                  :approved
                                )
  end

end
