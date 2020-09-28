class HomesController < ApplicationController

	def top
	end

	def home
		if current_user.selected_store == nil
			@schedule_title = "プライベート"
		else
			@store = Store.find(current_user.selected_store)
			@schedule_title = @store.name
			@submitted_shifts = SubmittedShift.where(user_id: current_user.id, store_id: @store.id)
		end
	end

	def change_selected_store
		current_user.update(selected_store: params[:id])
		redirect_to home_path
	end



end
