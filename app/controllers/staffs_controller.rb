class StaffsController < ApplicationController
	def new
		@staff = Staff.new
	end

	def index
		@staffs = Staff.where(store_id: current_user.selected_store, is_unsubscribe: false)
	end

	def create
		staff = Staff.new(staff_params)
		if staff.save
			flash[:notice] = "send staff authentication"
			redirect_to home_path
		else
			flash[:notice] = "false"
			redirect_to new_staff_path
		end
	end

	def show
		@staff = Staff.find(params[:id])
	end

	def update
		staff = Staff.find(params[:id])
		staff.update(staff_params)
		redirect_to home_path
	end

	def permit
		staff = Staff.find(params[:id])
		staff.update(is_permitted_status: true)
		redirect_to home_path
	end

	def authentication_admin
		staff = Staff.find(params[:id])
		staff.update(is_admin: true)
		redirect_to home_path
	end

	def unsubscribe
		staff = Staff.find(params[:id])
		staff.update(is_unsubscribe: true)
		redirect_to home_path
	end

	private
	def staff_params
		params.require(:staff).permit(:store_id, :hourly_pay, :transportation_expenses)
	end



end
