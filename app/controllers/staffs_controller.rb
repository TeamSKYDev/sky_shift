class StaffsController < ApplicationController
	def new
		@staff = Staff.new
		@store = Store.search(params[:search])
	end

	def index
		@staffs = Staff.where(store_id: current_user.selected_store, is_unsubscribe: false)
	end

	def create
		store = Store.find_by(uuid: params[:store][:uuid])
		staff = Staff.new
		staff.user_id = current_user.id
		staff.store_id = store.id
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
		redirect_to store_path(current_user.selected_store)
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
