class LabelsController < ApplicationController
	before_action :check_selected_store

	def new
		@label = Label.new
		@store = Store.find(current_user.selected_store)
	end

	def index
		@staff = Staff.find_by(user_id: current_user.id, store_id: current_user.selected_store)
		if @staff.is_admin != true
			redirect_to home_path
		end
		@store = Store.find_by(id: current_user.selected_store)
		@title = @store.name + "　ラベル管理"
		@labels = Label.where(store_id: @store.id).order(created_at: :desc)
	end

	def create
		@label = Label.new(label_params)
		respond_to do |format|
			if @label.save
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
		@label = Label.find(params[:id])
		@store = Store.find(current_user.selected_store)
		staff_ids = Staff.where(store_id: @label.store_id, is_permitted_status: true, is_unsubscribe: false).pluck(:user_id)
		@users = User.where(id: [staff_ids])
	end

	def show
		@label = Label.find(params[:id])
		@staffs = @label.staffs.where(is_permitted_status: true, is_unsubscribe: false)
	end

	def update
		@label = Label.find(params[:id])

		assigned_staffs_id = @label.staffs.where(store_id: @label.store_id).pluck(:id)
		StaffLabel.where(label_id: @label.id, staff_id: [assigned_staffs_id]).destroy_all

		if params[:label][:select_staff_ids].present?
			params[:label][:select_staff_ids].each do |select_staff_id|
				staff_label = StaffLabel.new
				staff_label.label_id = @label.id
				staff_label.staff_id = select_staff_id
				staff_label.save!
			end
		end
		if @label.update(label_params)
			flash[:notice] = "更新しました"
		end

		redirect_to labels_path
	end

	def destroy
		@label = Label.find(params[:id])
		label_name = @label.name
		@label.destroy
		flash[:notice] = "destroy label [#{label_name}]"
		redirect_to labels_path
	end

	private
	def label_params
		params.require(:label).permit(:name, :work_type, :store_id, :content)
	end
end

