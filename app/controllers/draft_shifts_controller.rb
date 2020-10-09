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
		@submitted_shifts = SubmittedShift.where(store_id: @store.id, start_time: @date.in_time_zone.all_day, status: true).order(:start_time)
		@draft_shifts = DraftShift.where(store_id: @store.id, start_time: @date.in_time_zone.all_day).order(:start_time)
		@draft_shift = DraftShift.new
		@draft_shift.start_time = @date
		@draft_shift.end_time = @date
		user_ids = Staff.where(store_id: @store.id, is_permitted_status: true, is_unsubscribe: false).pluck(:user_id)
		# @usersにヘルプを追加
		@users = User.where(id: [user_ids])
	end

	def create
		@draft_shift = DraftShift.new(draft_shift_params)
		if @draft_shift.save!
			flash[:notice] = "create new draft"
		else
			flash[:notice] = "cannot create draft"
		end
		redirect_to request.referer
	end

	def update
		@draft_shift = DraftShift.find(params[:id])
		if @draft_shift.update(draft_shift_params)
			flash[:notice] = "update draft"
		else
			flash[:notice] = "cannot create draft"
		end
		redirect_to request.referer
	end

	def destroy
		@draft_shift = DraftShift.find(params[:id])
		@draft_shift.destroy
		flash[:notice] = "destroy draft"
		redirect_to daily_draft_shifts_path
	end

	private
	def draft_shift_params
		params.require(:draft_shift).permit(:store_id, :user_id, :start_time, :end_time)
	end

end
