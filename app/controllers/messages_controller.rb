class MessagesController < ApplicationController
    def create
        if Message.create(message_params)
            flash[:notice] = "send succesfully"
            redirect_to room_messages_path(params[:room_id])
        else
            flash[:notice] = "can't send"
            redirect_to room_messages_path(params[:room_id])
        end
    end

    def index
        @room = Room.find(params[:room_id])
        @messages = @room.messages
        @message = Message.new
    end

    private
    def message_params
        params.require(:message).permit(:creator_id, :room_id, :content).merge({ creator_id: current_user.id, room_id: params[:room_id] })
    end
end
