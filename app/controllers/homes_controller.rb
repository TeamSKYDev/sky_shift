class HomesController < ApplicationController
	before_action :set_temporary_table, only: [:home]

	def top
		if user_signed_in?
			redirect_to home_path
		end
	end


	def home
		if params[:start_date].present?
			@date = params[:start_date]
		else
			@date = Date.current.beginning_of_month
		end

		if current_user.selected_store.blank?
			@title = "private"
			@private_schedules = current_user.private_schedules
			@submitted_shifts = current_user.submitted_shifts.where(start_time: @date.in_time_zone.all_month)
			@decided_shifts = current_user.decided_shifts.where(start_time: @date.in_time_zone.all_month)
		else
			@store = Store.find(current_user.selected_store)
			@title = @store.name

			@submitted_shifts = current_user.submitted_shifts.where(store_id: @store.id, start_time: @date.in_time_zone.all_month)
			@decided_shifts = current_user.decided_shifts.where(store_id: @store.id, start_time: @date.in_time_zone.all_month)

		end

		if @private_schedules.present?
			@private_schedules.each do |private_schedule|
				@event = Event.new
				@event.title = private_schedule.title
				@event.content = private_schedule.content
				@event.private_id = private_schedule.id
				@event.start_time = private_schedule.start_time
				@event.end_time = private_schedule.end_time
				@event.shedule_status = true
				@event.save!
			end
		end

		if @submitted_shifts.present?
			@submitted_shifts.each do |submitted_shift|
				@event = Event.new
				if submitted_shift.status == true
					@event.title = "提" + submitted_shift.store.name
				else
					@event.title = "未"+ submitted_shift.store.name
				end
				@event.start_time = submitted_shift.start_time
				@event.end_time = submitted_shift.end_time
				@event.save!
			end
		end

		if @decided_shifts.present?
			@decided_shifts.each do |decided_shift|
				@event = Event.new
				@event.title = decided_shift.store.name
				@event.start_time = decided_shift.start_time
				@event.end_time = decided_shift.end_time
				@event.save!
			end
		end

		@events = Event.all

		# @decided_shifts = DecidedShift.where(store_id: @store.id, user_id: current_user.id)
	end

	def select_schedule
		@date = params[:date]
		@private_schedules = PrivateSchedule.where(user_id: current_user.id, start_time: @date.in_time_zone.all_day)
		@submitted_shifts = SubmittedShift.where(user_id: current_user.id, start_time: @date.in_time_zone.all_day)
		@decided_shifts = DecidedShift.where(user_id: current_user.id, start_time: @date.in_time_zone.all_day)
		store_ids = Staff.where(user_id: current_user.id, is_permitted_status: true, is_unsubscribe: false).pluck(:store_id)
		@stores = Store.where(id: [store_ids])
	end

	def change_selected_store
		if params[:id].present?
			current_user.update(selected_store: params[:id])
		else
			current_user.update(selected_store: nil)
		end
		redirect_to home_path
	end

	def submittion_destination
		store_ids = Staff.where(user_id: current_user.id, is_permitted_status: true, is_unsubscribe: false).pluck(:store_id)
		@stores = Store.where(id: [store_ids])
		@start_date = params[:start_date]
	end



end
