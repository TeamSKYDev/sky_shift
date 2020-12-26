class SubmittedShiftsController < ApplicationController
	def new
		@submitted_shift = SubmittedShift.new
		date = Date.parse(params[:start_date])
		@submitted_shift.start_time = (date + Time.parse("09:00").seconds_since_midnight.seconds).to_datetime
        @submitted_shift.end_time = (date + Time.parse("10:00").seconds_since_midnight.seconds).to_datetime

		if params[:store].present?
			@store =  Store.find(params[:store][:store_id])
		else
			@store = Store.find(current_user.selected_store)
		end
		@submitted_shifts = SubmittedShift.where(user_id: current_user.id, store_id: @store.id, start_time: params[:start_date].in_time_zone.all_day).order(:start_time)
	end

	def create
		@submitted_shift = SubmittedShift.new(submitted_shift_params)
		@submitted_shift.user_id = current_user.id

		respond_to do |format|
			if @submitted_shift.save
			    # format.html { redirect_to staffs_path, notice: 'User was successfully created.' }
			    # format.json { render :edit, status: :created, location: @staff }
			    format.js { 
			        @status = "success" 
			        # redirect_to carender_path
			    }
			else
			    # format.html { render :new }
			    # format.json { render json: @staff.errors, status: :unprocessable_entity }
			    format.js { @status = "fail" }
			end
		end
	end

	def edit
		@submitted_shift = SubmittedShift.find(params[:id])
		@date = @submitted_shift.start_time.to_date
		@store = Store.find(@submitted_shift.store.id)
		@submitted_shifts = SubmittedShift.where(user_id: current_user.id, store_id: @store.id, start_time: @date.in_time_zone.all_day).where.not(id: params[:id]).order(:start_time)
	end

	def update
		@submitted_shift = SubmittedShift.find(params[:id])
		@submitted_shift.user_id = current_user.id
		if @submitted_shift.update(submitted_shift_params)
		else
			flash[:error] = "error"
		end
		redirect_to home_path
	end

	def destroy
		submitted_shift = SubmittedShift.find(params[:id])
		submitted_shift.destroy
		redirect_to request.referer
	end

	def confirm
		@store = Store.find(current_user.selected_store)
		@period = params[:start_date].in_time_zone.all_month
		@submitted_shifts = SubmittedShift.where(user_id: current_user.id, store_id: current_user.selected_store, status: false, start_time: @period).order(:start_time)
	end

	def submit
		@period = params[:start_date].in_time_zone.all_month
		@submit_shifts = SubmittedShift.where(user_id: current_user.id, store_id: current_user.selected_store, status: false, start_time: @period,)
		@submit_shifts.each do |shift|
			if shift.update(status: true)
				# 提出と同時に下書きシフトを作成
				draft_shift = DraftShift.new
				draft_shift.user_id = shift.user_id
				draft_shift.store_id = shift.store_id
				draft_shift.start_time = shift.start_time
				draft_shift.end_time = shift.end_time
				draft_shift.save!
			end

		end
		flash[:notice] = "提出しました"
		redirect_to request.referer
	end

    private
    def submitted_shift_params
        params.require(:submitted_shift).permit(:user_id, :store_id, :start_time, :end_time)
    end

end
