class LabelsController < ApplicationController
	def index
		@label = Label.new
		@labels = Label.where(store_id: current_user.selected_store)
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
		@label = Label.find(params[:id])
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

