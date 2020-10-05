class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?
	before_action :authenticate_user!, except: [:top]
	before_action :get_stores

	def get_stores
		if current_user.present?
		 	store_ids = Staff.where(user_id: current_user.id, is_permitted_status: true).pluck(:store_id)
		 	@stores = Store.where(id: [store_ids])

		end
	end

	def after_sign_in_path_for(resouce)
		home_path
	end

	def check_selected_store
		if current_user.selected_store.blank?
			redirect_to home_path
		end
	end

	def self.render_with_signed_in_user(user, *args)
		ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
		proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap{|i| i.set_user(user, scope: :user) }
		renderer = self.renderer.new('warden' => proxy)
		renderer.render(*args)
	end

	private
	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name, :first_name, :telephone_number])
	end

end
