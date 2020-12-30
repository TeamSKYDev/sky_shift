class DraftShiftsController < ApplicationController
	before_action :check_selected_store
	before_action :set_temporary_table, only: [:index]

	def submitted
		@date = params[:start_date]
		@store = Store.find_by(id: current_user.selected_store)
		@submitted_shifts = SubmittedShift.where(store_id: @store.id, start_time: @date.in_time_zone.all_day, status: true).order(:start_time)
	end

	def index
		@store = Store.find_by(id: current_user.selected_store)
		@title = @store.name + "　シフト管理"
		@staff = Staff.find_by(user_id: current_user.id, store_id: @store.id)
		if @staff.is_admin == false
			redirect_to home_path
		end
		if params[:start_date].present?
			@date = params[:start_date]
		else
			@date = Date.current.beginning_of_month
		end

		@draft_shifts = DraftShift.where(store_id: @store.id, start_time: @date.in_time_zone.all_month)
		@decided_shifts = DecidedShift.where(store_id: @store.id, start_time: @date.in_time_zone.all_month)

		if @draft_shifts.present?
			@draft_shifts.each do |draft_shift|
				@event = Event.new
				@event.start_time = draft_shift.start_time
				@event.end_time = draft_shift.end_time
				@event.shedule_status = false
				@event.save!
			end
		end


		if @decided_shifts.present?
			@decided_shifts.each do |decided_shift|
				@event = Event.new
				@event.start_time = decided_shift.start_time
				@event.end_time = decided_shift.end_time
				@event.shedule_status = true
				@event.save!
			end
		end

		@events = Event.all
	end

	def daily
		@store = Store.find_by(id: current_user.selected_store)
		@title = @store.name + "　シフト管理"
		@staff = Staff.find_by(user_id: current_user.id, store_id: @store.id)

		if @staff.is_admin == false
			redirect_to home_path
		end

		if params[:start_date].present?
			@date = params[:start_date].to_date
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
		user_ids.unshift(0)
		@users = User.where(id: [user_ids])

		@decided_shifts = DecidedShift.where(store_id: @store.id, start_time: @date.in_time_zone.all_day).order(:start_time)
	end

	def create
		@draft_shift = DraftShift.new(draft_shift_params)
		if @draft_shift.save!
			flash[:notice] = "追加しました"
		else
			flash[:error] = "error"
		end
		redirect_to request.referer
	end

	def update
		@draft_shift = DraftShift.find(params[:id])
		if @draft_shift.update(draft_shift_params)
			flash[:notice] = "更新しました"
		else
			flash[:error] = "error"
		end
		redirect_to request.referer
	end

	def destroy
		@draft_shift = DraftShift.find(params[:id])
		@draft_shift.destroy
		flash[:notice] = "削除しました"
		redirect_to request.referer
	end

	private
	def draft_shift_params
		params.require(:draft_shift).permit(:store_id, :user_id, :start_time, :end_time)
	end

end
