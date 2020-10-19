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
				@date = params[:start_date]
				@month_submitted_shifts = SubmittedShift.where(user_id: current_user.id, store_id: @store.id, start_time: params[:start_date].in_time_zone.all_month)
			else
				@date = Date.current.beginning_of_month
				@month_submitted_shifts = SubmittedShift.where(user_id: current_user.id, store_id: @store.id, start_time: Date.today.in_time_zone.all_month)
			end
		end
		#ActiveRecord::Base.connection.drop_table('events')
		ActiveRecord::Base.connection.create_table('events', temporary: true, force: true) do |t|
		  # t.integer :user_id    , null: true
		  t.string :title      , null: false
		  t.text   :content
		  t.datetime  :start_time , null: false
		  t.datetime  :end_time

		  t.timestamps null: false
		end

		klass = Class.new(ActiveRecord::Base) do |c|
		  c.table_name = 'events'
		end
		Object.const_set('Event', klass)

		if @month_submitted_shifts.present?
			@month_submitted_shifts.each do |submitted_shift|
				@event = Event.new
				if submitted_shift.status == true
					@event.title = submitted_shift.start_time.strftime("%H:%M") + "~" + submitted_shift.end_time.strftime("%H:%M")
				else
					@event.title = "未"+ submitted_shift.start_time.strftime("%H:%M") + "~" + submitted_shift.end_time.strftime("%H:%M")
				end
				@event.start_time = submitted_shift.start_time
				@event.end_time = submitted_shift.end_time
				@event.save!
			end
		end
		@event = Event.new(start_time: Date.today, title: "aaa").save!
		@events = Event.all

		# @decided_shifts = DecidedShift.where(store_id: @store.id, user_id: current_user.id)
	end

	def change_selected_store
		current_user.update(selected_store: params[:id])
		redirect_to home_path
	end



end
