class PrivateSchedulesController < ApplicationController

    def new
        @private_schedule = PrivateSchedule.new
    end

    def edit
        @private_schedule = PrivateSchedule.find(params[:id])
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
