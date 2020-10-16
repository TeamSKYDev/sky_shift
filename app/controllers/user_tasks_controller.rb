class UserTasksController < ApplicationController
	def new
		@task = Task.find(params[:id])
		@user_task = UserTask.new
		staff_ids = Staff.where(store_id: @task.store.id, is_permitted_status: true).pluck(:user_id)
		@users = User.where(id: [staff_ids])
	end

	def index
		store_ids = Staff.where(user_id: current_user.id, is_permitted_status: true).pluck(:store_id)
		# @stores = Store.where(id: [store_ids])
		task_ids = Task.where(store_id: [store_ids], is_announced: false).pluck(:id)
		@user_tasks = UserTask.where(user_id: current_user.id, task_id: [task_ids], is_completed: false)
		@public_tasks = Task.where(store_id: [store_ids], is_announced: true)
	end

	def create
		params[:user_task][:assign_task_ids].each do |assign_task_id|
			@user_task = UserTask.new(user_task_params)
			@user_task.user_id = assign_task_id
			@user_task.save
		end
		redirect_to tasks_path
	end

	def update
	end

	def destroy
	end

	private
	def user_task_params
		params.require(:user_task).permit(:user_id, :task_id, {assign_task_ids: []})
	end

end
