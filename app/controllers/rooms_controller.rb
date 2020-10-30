class RoomsController < ApplicationController
    before_action :check_room, only: %i[show]

	def check_room
		if current_user.selected_store.blank?
			redirect_to home_path
		end
    end
    
    def new
        @room = Room.new
        @stores = current_user.stores
        @store = Store.find(current_user.selected_store)
        @users = Store.find(current_user.selected_store).users.where.not(id: current_user)
    end

    def show
        @room = current_user.rooms.find(params[:id])
        @messages = @room.messages.includes(:user)
        @message = Message.new
    end

    def create
        @room = current_user.rooms.build(room_params)
        # @room.store_id = Store.find(current_user.selected_store).id
        
        respond_to do |format|
            if current_user.save
                # format.html { redirect_to staffs_path, notice: 'User was successfully created.' }
                # format.json { render :edit, status: :created, location: @staff }
                format.js { @status = "success" }
            else
                # format.html { render :new }
                # format.json { render json: @staff.errors, status: :unprocessable_entity }
                format.js { @status = "fail" }
            end
        end
    end

    def index
        @title = "トークルーム"
        @rooms = current_user.rooms
        # binding.irb
    end

    def destroy
        @room = Room.find(params[:id])
        @room_user = RoomUser.find_by(room_id: params[:id], user_id: current_user.id)
        room_name = @room.name
        
        @room_user.destroy
    
        if !@room.users.present?
            @room.destroy
        end
        flash[:notice] = "withdraw #{room_name}"
        redirect_to rooms_path
    end

    def get_users
        render partial: 'users', locals: {store_id: params[:store_id]}
    end

    private
    def room_params
		params.require(:room).permit(:name, :memo, :store_id, user_ids: [])
	end
end
