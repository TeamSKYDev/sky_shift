class LabelsController < ApplicationController
	before_action :check_selected_store

	def index
		@title = "ラベル管理"
		@staff = Staff.find_by(user_id: current_user.id, store_id: current_user.selected_store)
		if @staff.is_admin != true
			redirect_to home_path
		end
		@label = Label.new
		@all_labels_position = Label.where(store_id: @staff.store_id, work_type: "position")
		@all_labels_ability = Label.where(store_id: @staff.store_id, work_type: "ability")
		@all_labels_rank = Label.where(store_id: @staff.store_id, work_type: "rank")
		@all_labels_other = Label.where(store_id: @staff.store_id, work_type: "other")
		@store = Store.find_by(id: current_user.selected_store)
	end

	def create
		@label = Label.new(label_params)
		@label.store_id = current_user.selected_store
		if @label.save
			flash[:notice] = "create new label"
			redirect_to labels_path
		else
			flash[:notice] = "cannot create"
			@labels = Label.where(store_id: current_user.selected_store)
			@store = Store.find_by(id: current_user.selected_store)
			render "index"
		end
	end

	def edit
		@title = "ラベル管理"
		@label = Label.find(params[:id])
		@staff = Staff.find_by(user_id: current_user.id)
		if @staff.is_admin != true
			redirect_to home_path
		end
	end

	def update
		@label = Label.find(params[:id])
		if @label.update(label_params)
			flash[:notice] = "update label"
			redirect_to labels_path
		else
			flash[:notice] = "cannot update"
			render "edit"
		end
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
		params.require(:label).permit(:name, :work_type)
	end
end

