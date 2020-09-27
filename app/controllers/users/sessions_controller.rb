# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :reject_user, only: [:create]
  before_action :reset_selected_store, only: [:destroy]

  def reset_selected_store
    current_user.update(selected_store: nil)
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def reject_user
    my_data = User.find_by(email: params[:user][:email])

    if my_data.active_for_authentication? == false
      flash[:notice] = "already unsubsucribe"
      redirect_to new_uer_session_path
    end

  end
end
