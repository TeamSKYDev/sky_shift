class RoomsController < ApplicationController
    before_action :check_room, only: %i[show]

	def check_room
		if current_user.selected_store.blank?
			redirect_to home_path
		end
    end
    
    def new
        @room = Room.new
        @users = Store.find(current_user.selected_store).users
    end

    def show
        @room = current_user.rooms.find(params[:id])
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
        @rooms = current_user.rooms.where(store_id: current_user.selected_store)
        # binding.irb
    end

    private
    def room_params
		params.require(:room).permit(:name, :memo, user_ids: [])
	end
end
