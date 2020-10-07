class DraftShiftsController < ApplicationController
	before_action :check_selected_store

	def new
	end

	def index
		@store = Store.find_by(id: current_user.selected_store)
		if Staff.find_by(user_id: current_user.id).is_admin == false
			redirect_to home_path
		end
		if params[:start_date].present?
			@date = params[:start_date]
		else
			@date = Date.current.beginning_of_month
		end

		@draft_shifts = DraftShift.where(store_id: @store.id, start_time: @date.in_time_zone.all_month)
	end

	def daily
		@store = Store.find_by(id: current_user.selected_store)
		if Staff.find_by(user_id: current_user.id).is_admin == false
			redirect_to home_path
		end

		if params[:start_date].present?
			@date = params[:start_date]
		else
			@date = Date.current.beginning_of_month
		end
		@submitted_shifts = SubmittedShift.where(store_id: @store.id, start_time: @date.in_time_zone.all_day, status: true)
		@draft_shifts = DraftShift.where(store_id: @store.id, start_time: @date.in_time_zone.all_day)

	end

	def create
	end

	def update
	end

	def destroy
	end

end
