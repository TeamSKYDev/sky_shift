class HomesController < ApplicationController

	def top
	end

	def index
		@private_schedules = PrivateSchedule.all
	end

	def home
		if current_user.selected_store == nil
			@schedule_title = "プライベート"
		else
			@store = Store.find(current_user.selected_store)
			@schedule_title = @store.name
			@submitted_shifts = SubmittedShift.where(user_id: current_user.id, store_id: @store.id)
			if params[:start_date]
				@month_submitted_shifts = SubmittedShift.where(user_id: current_user.id, store_id: @store.id, start_time: params[:start_date].in_time_zone.all_month)
			else
				@month_submitted_shifts = SubmittedShift.where(user_id: current_user.id, store_id: @store.id, start_time: Date.today.in_time_zone.all_month)
			end
		end
	end

	def change_selected_store
		current_user.update(selected_store: params[:id])
		redirect_to home_path
	end



end
