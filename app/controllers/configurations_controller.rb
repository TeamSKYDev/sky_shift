class ConfigurationsController < ApplicationController

	def index
		@title = "設定"

		admin_store_ids = Staff.where(user_id: current_user.id, is_admin: true).pluck(:store_id)
		@admin_stores = Store.where(id: [admin_store_ids])
	end

	def config_store
		store = Store.find(params[:id])
		current_user.update(selected_store: store.id)
		redirect_to store_path(store)
	end
end
