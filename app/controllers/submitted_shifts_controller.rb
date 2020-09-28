class SubmittedShiftsController < ApplicationController
	def new
		@submitted_shift = SubmittedShift.new
		@submitted_shift.start_time = params[:start_date]
		@submitted_shift.end_time = params[:start_date]
		@store = Store.find(current_user.selected_store)
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
	end

	def update
	end

	def submit
	end

	def destroy
	end

    private
    def submitted_shift_params
        params.require(:submitted_shift).permit(:user_id, :store_id, :start_time, :end_time)
    end

end
