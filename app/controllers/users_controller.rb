class UsersController < ApplicationController
	def show
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update(user_params)
			flash[:notice] = "update user information successfully"
			redirect_to home_path
		else
			flash[:notice] = "update false"
			render "show"
		end

	end

	def select_store
		@user = User.find(params[:id])
		if @user.update(selected_store: params[:user][:selected_store])
			flash[:notice] = "update user information successfully"
			redirect_to home_path
		else
			flash[:notice] = "update false"
			redirect_to home_path
		end
	end

	def unsubscribe
		my_data = User.find(current_user.id)
	    if my_data.update(is_unsubscribe: true)
	        reset_session
	        flash[:notice] = "unsubscribe succesfully"
	        redirect_to root_path
	    else
	      flash[:notice] = "cannot unsubscribe"
	      redirect_to home_path
	    end
	end

	private
	def user_params
		params.require(:user).permit(:last_name, :first_name, :kana_last_name, :kana_first_name, :telephone_number, :sex, :profile_image)
	end


end