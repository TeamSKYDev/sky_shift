class MessagesController < ApplicationController
    def create
        if Message.create(message_params)
            redirect_to room_path(params[:room_id])
        else
            redirect_to room_path(params[:room_id])
        end
    end

    def message_params
        params.require(:message).permit(:admin_id, :room_id, :content).merge({ admin_id: current_admin.id, room_id: params[:room_id] })
    end
end
