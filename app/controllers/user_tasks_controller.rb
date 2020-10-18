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

	def past_index
		#@user_tasks = current_user.user_tasks.where(is_completed: true)
		@user_tasks = UserTask.where(is_completed: true, user_id: current_user.id)
	end

	def past_assign
		@store = Store.find(current_user.selected_store)
		task_ids = @store.tasks.where(is_official: true).pluck(:id)
		staff_user_ids = Staff.where(store_id: current_user.selected_store, is_permitted_status: true).pluck(:user_id)

		@user_tasks = UserTask.where(user_id: [staff_user_ids], task_id: [task_ids])

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
		@user_task = UserTask.find(params[:id])
		@user_task.update(is_completed: true)
		redirect_to user_tasks_path
	end

	def destroy
		@user_task = UserTask.find(params[:id])
		@user_task.destroy
		redirect_to user_tasks_path
	end

	private
	def user_task_params
		params.require(:user_task).permit(:user_id, :task_id, {assign_task_ids: []})
	end

end
