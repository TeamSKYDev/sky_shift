class LabelsController < ApplicationController
	def index
		@label = Label.new
		@labels = Label.where(store_id: current_user.selected_store)
		@store = Store.find_by(id: current_user.selected_store)
	end

	def create
		label = Label.new(label_params)
		label.store_id = current_user.selected_store
		if label.save
			flash[:notice] = "create new label"
		else
			flash[:notice] = "cannot create"
		end
		redirect_to labels_path
	end

	def edit
	end

	def update
	end

	def destroy
	end

	private
	def label_params
		params.require(:label).permit(:name, :work_type)
	end
end

