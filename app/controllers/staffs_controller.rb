class StaffsController < ApplicationController
	before_action :check_selected_store, except: [:new, :create]

	def new
		@staff = Staff.new
		@store = Store.search(params[:search])
	end

	def index
		staff = Staff.find_by(user_id: current_user.id, store_id: current_user.selected_store)
		if staff.is_admin == false
			redirect_to home_path
		end
		@staffs = Staff.where(store_id: current_user.selected_store, is_unsubscribe: false)
	end

	def create
		store = Store.find_by(uuid: params[:store][:uuid])
		related_staff = Staff.find_by(store_id: store.id, user_id: current_user.id)

		if related_staff.present?
			if related_staff.is_permitted_status == true
				flash[:notice] = "already permit"
			else
				flash[:notice] = "already send. wait for staff authentication."
			end
			redirect_to new_staff_path
		else
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
	end

	def show
		@staff = Staff.find(params[:id])
		if Staff.find_by(user_id: current_user.id, store_id: @staff.store_id).is_permitted_status != true
			redirect_to home_path
		end
		@labels = Label.where(store_id: @staff.store_id)
	end

	def update
		staff = Staff.find(params[:id])
		staff_label = StaffLabel.new
		params[:select_label_ids].each do |select_label_id|
			staff_label.label_id = select_label_id
			staff_label.staff_id = staff.id
			staff.save!
		end

		if staff.update(staff_params)
			flash[:notice] = "update successhully"
		else
			flash[:notice] = "connot update"
		end
		redirect_to staff_path(staff.id)
	end

	def permit
		staff = Staff.find(params[:id])
		staff.update(is_permitted_status: true)
		redirect_to staff_path(staff)
	end

	def authentication_admin
		staff = Staff.find(params[:id])
		staff.update(is_admin: true)
		redirect_to home_path
	end

	def unsubscribe
		staff = Staff.find(params[:id])
		staff.update(is_unsubscribe: true)
		redirect_to staffs_path
	end

	private
	def staff_params
		params.require(:staff).permit(:store_id, :hourly_pay, :transportation_expenses, :is_admin, select_label_ids: [])
	end



end
