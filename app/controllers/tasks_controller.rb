class TasksController < ApplicationController

	def new
		@task = Task.new
		@store = Store.find(current_user.selected_store)
	end

	def index
		@store = Store.find(current_user.selected_store)
		@title = @store.name + " タスク管理"
		@staff = Staff.find_by(user_id: current_user.id, store_id: @store.id)
		if @staff.is_admin == false
			redirect_to home_path
		end

		@tasks = Task.where(store_id: @store.id).order(created_at: :desc)
	end

	def create
		@store = Store.find(current_user.selected_store)
		@staff = Staff.find_by(user_id: current_user.id, store_id: @store.id)

		@task = Task.new(task_params)
		@task.creator_id = current_user.id
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

	def show
		@task = Task.find(params[:id])
	end

	def show_admin
		@task = Task.find(params[:id])
		@user_task = UserTask.new
		staff_ids = Staff.where(store_id: @task.store.id, is_permitted_status: true).pluck(:user_id)
		@users = User.where(id: [staff_ids])
	end

	def edit
		@task = Task.find(params[:id])
		@store = Store.find(current_user.selected_store)
	end

	def update
		@task = Task.find(params[:id])
		@task.update(task_params)
		redirect_to request.referer
	end

	def destroy
		@task = Task.find(params[:id])
		@task.destroy
		redirect_to request.referer
	end

	private

	def task_params
		params.require(:task).permit(:title, :content, :store_id, :is_announced)
	end
end
