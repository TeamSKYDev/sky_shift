class PrivateSchedulesController < ApplicationController

    def new
        @private_schedule = PrivateSchedule.new
        date = Date.parse(params[:date])
        @private_schedule.start_time = (date + Time.parse("09:00").seconds_since_midnight.seconds).to_datetime
        @private_schedule.end_time = (date + Time.parse("10:00").seconds_since_midnight.seconds).to_datetime
    end

    def edit
        @private_schedule = current_user.private_schedules.find(params[:id])
    end

    def update
        @private_schedule = current_user.private_schedules.find(params[:id])
        respond_to do |format|
            if @private_schedule.update(private_shcedule_params)
                # format.html { redirect_to staffs_path, notice: 'User was successfully created.' }
                # format.json { render :edit, status: :created, location: @staff }
                format.js { @status = "success" }
            else
                # format.html { render :new }
                # format.json { render json: @staff.errors, status: :unprocessable_entity }
                format.js { @status = "fail" }
            end
        end
    
    end

    def destroy
        @private_schedule = current_user.private_schedules.find(params[:id])
        @private_schedule.destroy
    end

    def create
        @private_schedule = current_user.private_schedules.build(private_shcedule_params)

        respond_to do |format|

            if current_user.save
                # format.html { redirect_to staffs_path, notice: 'User was successfully created.' }
                # format.json { render :edit, status: :created, location: @staff }
                format.js { @status = "success" }
            else
                # format.html { render :new }
                # format.json { render json: @staff.errors, status: :unprocessable_entity }
                format.js { @status = "fail" }
            end
        end
    end

    private
    def private_shcedule_params
        params.require(:private_schedule).permit(:title, :content, :start_time, :end_time)
    end
end
