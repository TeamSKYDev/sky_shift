class StaffsController < ApplicationController
	before_action :check_selected_store, except: [:new, :create]

	def new
		@staff = Staff.new
		@store = Store.search(params[:search])
	end

	def index
		@title = "スタッフ管理"
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
		@title = "スタッフ詳細"
		@staff = Staff.find(params[:id])
		@access_staff = Staff.find_by(user_id: current_user.id, store_id: @staff.store_id)
		if @access_staff.is_permitted_status != true
			redirect_to home_path
		end
		label_position_ids = StaffLabel.where(staff_id: @staff.id).pluck(:label_id)
		label_ability_ids = StaffLabel.where(staff_id: @staff.id).pluck(:label_id)
		label_rank_ids = StaffLabel.where(staff_id: @staff.id).pluck(:label_id)
		label_other_ids = StaffLabel.where(staff_id: @staff.id).pluck(:label_id)

		@label_position = Label.where(id: [label_position_ids], store_id: @staff.store_id, work_type: "position")
		@label_ability = Label.where(id: [label_ability_ids], store_id: @staff.store_id, work_type: "ability")
		@label_rank = Label.where(id: [label_rank_ids], store_id: @staff.store_id, work_type: "rank")
		@label_other = Label.where(id: [label_other_ids], store_id: @staff.store_id, work_type: "other")

		@all_labels_position = Label.where(store_id: @staff.store_id, work_type: "position")
		@all_labels_ability = Label.where(store_id: @staff.store_id, work_type: "ability")
		@all_labels_rank = Label.where(store_id: @staff.store_id, work_type: "rank")
		@all_labels_other = Label.where(store_id: @staff.store_id, work_type: "other")
	end

	def update
		staff = Staff.find(params[:id])

		assigned_labels_id = staff.labels.where(store_id: staff.store_id).pluck(:id)
		StaffLabel.where(label_id: [assigned_labels_id], staff_id: staff.id).destroy_all

		if params[:staff][:select_label_ids].present?
			params[:staff][:select_label_ids].each do |select_label_id|
				staff_label = StaffLabel.new
				staff_label.label_id = select_label_id
				staff_label.staff_id = staff.id
				staff_label.save!
			end
		end

		if staff.update(staff_params)
			flash[:notice] = "update successfully"
		else
			flash[:notice] = "connot update"
		end
		redirect_to staff_path(staff.id)
	end

	def permit
		staff = Staff.find(params[:id])
		# 連携状態にしてる
		staff.update(is_permitted_status: true)
		# 連携状態になったら管理者とのトークルームを作る。
		staffs = Staff.where(store_id: staff.store_id, is_admin: true)
		
		staffs.each do |s|
			room = staff.user.rooms.build(store_id: staff.store_id, user_ids: ["",s.user.id,staff.user.id])
			room.save
			# binding.irb
		end
		# メインルームにも忘れずに追加。
		room_user = RoomUser.new(room_id: Store.find(current_user.selected_store).main_room_id, user_id: staff.user.id)
		room_user.save
		# binding.irb
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
		params.require(:staff).permit(:store_id, :hourly_pay, :transportation_expenses, :is_admin, {select_label_ids: []})
	end



end
