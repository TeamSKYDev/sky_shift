class TasksController < ApplicationController

	def new
		@task = Task.new
		@store = Store.find(current_user.selected_store)
	end

	def index
		@store = Store.find(current_user.selected_store)
		@tasks = Task.where(store_id: @store.id)
	end

	def create
		@store = Store.find(current_user.selected_store)
		@staff = Staff.find_by(user_id: current_user.id, store_id: @store.id)

		@task = Task.new(task_params)
		@task.creatore_id = current_user.id
		if @staff.is_admin == true
			@task.is_official == true
		end
		respond_to do |format|
			if @task.save
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
		@task = Task.find(params[:id])
	end

	def update
	end

	def destroy
	end

	private

	def task_params
		params.require(:task).permit(:title, :content, :store_id, :is_announced)
	end
end