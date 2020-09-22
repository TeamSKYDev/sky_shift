class RoomsController < ApplicationController
    def new
        @room = Room.new
        @users = Store.find(current_user.selected_store).users
    end

    def show
        @room = Room.find(params[:id])
    end

    def create
        room = current_user.rooms.build(room_params)
        room.store_id = Store.find(current_user.selected_store).id
        # binding.irb
        if room.save
            flash[:notice] = "create succesfully"
            redirect_to new_room_path
        else
            flash[:notice] = "can't create"
            redirect_to new_room_path
        end
    end

    def index
        @rooms = current_user.rooms
        # binding.irb
    end

    private
    def room_params
		params.require(:room).permit(:name, :memo, user_ids: [])
	end
end
