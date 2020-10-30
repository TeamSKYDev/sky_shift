class HomesController < ApplicationController

	def top
	end

	def index
		@private_schedules = PrivateSchedule.all
	end

	def home
		#ActiveRecord::Base.connection.drop_table('events')
		ActiveRecord::Base.connection.create_table('events', temporary: true, force: true) do |t|
		  # t.integer :user_id    , null: true
		  t.string :title, null: false
		  t.text   :content
		  t.datetime  :start_time, null: false
		  t.datetime  :end_time
		  t.boolean :shedule_status, null: false, default: false

		  t.timestamps null: false
		end

		klass = Class.new(ActiveRecord::Base) do |c|
		  c.table_name = 'events'
		end
		Object.const_set('Event', klass)

		if params[:start_date].present?
			@date = params[:start_date]
		else
			@date = Date.current.beginning_of_month
		end


		if current_user.selected_store.blank?
			@title = "プライベート"
			@private_schedules = PrivateSchedule.all
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

	def change_selected_store
		if params[:id].present?
			current_user.update(selected_store: params[:id])
		else
			current_user.update(selected_store: nil)
		end
		redirect_to home_path
	end



end
