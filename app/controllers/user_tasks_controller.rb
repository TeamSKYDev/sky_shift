class UserTasksController < ApplicationController
	def new
		@task = Task.find(params[:id])
		@user_task = UserTask.new
		staff_ids = Staff.where(store_id: @task.store.id, is_permitted_status: true).pluck(:user_id)
		@users = User.where(id: [staff_ids])
	end

	def index
		@title = "タスク"
		store_ids = Staff.where(user_id: current_user.id, is_permitted_status: true).pluck(:store_id)
		# @stores = Store.where(id: [store_ids])
		task_ids = Task.where(store_id: [store_ids], is_announced: false).pluck(:id)
		@user_tasks = UserTask.where(user_id: current_user.id, task_id: [task_ids], is_completed: false)
		@public_tasks = Task.where(store_id: [store_ids], is_announced: true).order(created_at: :desc)
	end

	def past_index
		@title = "タスク"
		#@user_tasks = current_user.user_tasks.where(is_completed: true)
		@user_tasks = UserTask.where(is_completed: true, user_id: current_user.id).order(updated_at: :desc)
	end

	def past_assign
		@store = Store.find(current_user.selected_store)
		task_ids = @store.tasks.where(is_official: true).pluck(:id)
		staff_user_ids = Staff.where(store_id: current_user.selected_store, is_permitted_status: true).pluck(:user_id)

		@user_tasks = UserTask.where(user_id: [staff_user_ids], task_id: [task_ids]).order(created_at: :desc)
		@title = @store.name + " タスク管理"
	end

	def staff_assign
		@staff = Staff.find(params[:id])
		@tasks = Task.where(store_id: @staff.store.id, is_announced: false)
		@user_task = UserTask.new
	end


	def create
		if params[:user_task][:assign_task_ids].present?
			params[:user_task][:assign_task_ids].each do |assign_task_id|
				@user_task = UserTask.new(user_task_params)
				if @user_task.task_id.present?
					@user_task.user_id = assign_task_id
				else
					@user_task.task_id = assign_task_id
				end

				if UserTask.find_by(user_id: @user_task.user_id, task_id: @user_task.task_id, is_completed: false).present?
					flash[:error] = "重複がありました"
				else
					@user_task.save
				end
			end
		else
			flash[:error] = "✓を入れてください"
		end
		redirect_to request.referer
	end

	def show
		@user_task = UserTask.find(params[:id])
	end


	def update
		@user_task = UserTask.find(params[:id])
		@user_task.update(is_completed: true)
		redirect_to request.referer
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
