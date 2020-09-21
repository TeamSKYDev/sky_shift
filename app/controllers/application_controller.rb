class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?
	before_action :authenticate_user!, except: [:top]
	before_action :get_stores

	def get_stores
		if current_user.present?
		 	@stores = current_user.stores
		end
	end

	def after_sign_in_path_for(resouce)
		home_path
	end


	private
	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name, :first_name, :telephone_number])
	end

end
