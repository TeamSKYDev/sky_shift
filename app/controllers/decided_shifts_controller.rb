class DecidedShiftsController < ApplicationController
	before_action :check_selected_store

	def create
		@date = params[:start_date]
		draft_shifts = DraftShift.where(store_id: current_user.selected_store, start_time: @date.in_time_zone.all_day)
		draft_shifts.each do |draft_shift|
			decided_shift = DecidedShift.new
			decided_shift.user_id = draft_shift.user_id
			decided_shift.store_id = draft_shift.store_id
			decided_shift.start_time = draft_shift.start_time
			decided_shift.end_time = draft_shift.end_time
			if decided_shift.save!
				flash[:notice] = "create decided_shifts successfully"
			else
				flash[:notice] = "cannot create"
			end
		end
		draft_shifts.destroy_all

		redirect_to request.referer
	end

	def create_all
		period = params[:start_date].in_time_zone.all_month
		draft_shifts = DraftShift.where(store_id: current_user.selected_store, start_time: period)
		draft_shifts.each do |draft_shift|
			decided_shift = DecidedShift.new
			decided_shift.user_id = draft_shift.user_id
			decided_shift.store_id = draft_shift.store_id
			decided_shift.start_time = draft_shift.start_time
			decided_shift.end_time = draft_shift.end_time
			if decided_shift.save!
				flash[:notice] = "create decided_shifts successfully"
			else
				flash[:notice] = "cannot create"
			end
		end
		draft_shifts.destroy_all

		redirect_to request.referer

	end

	def edit
		@decided_shift = DecidedShift.find(params[:id])
		@store = @decided_shift.store
		user_ids = Staff.where(store_id: @store.id, is_permitted_status: true, is_unsubscribe: false).pluck(:user_id)
		# @usersにヘルプを追加
		user_ids.unshift(0)
		@users = User.where(id: [user_ids])
	end

	def update
		@decided_shift = DecidedShift.find(params[:id])
		@date = @decided_shift.start_time.to_date
		@decided_shift.update(decided_shift_params)
		redirect_to request.referer
	end

	def destroy
		@decided_shift = DecidedShift.find(params[:id])
		@decided_shift.destroy
		flash[:notice] = "確定シフトを削除しました"
		redirect_to request.referer
	end

	def decided_shift_params
		params.require(:decided_shift).permit(:user_id, :start_time, :end_time)
	end
end
