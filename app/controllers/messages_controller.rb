class MessagesController < ApplicationController
    def create
        @message = Message.new(message_params)

        respond_to do |format|
            if @message.save
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
        @room = current_user.rooms.find(params[:room_id])
        @messages = @room.messages.includes(:user)
        @message = Message.new
        # @rooms = current_user.rooms.where(store_id: current_user.selected_store)
    end

    def render_message
        # binding.pry
        message = Message.new(params.require(:message).permit(:creator_id, :room_id, :content, :created_at, :updated_at))
        render partial: 'message', locals: {message: message}
    end

    private
    def message_params
        params.require(:message).permit(:creator_id, :room_id, :content).merge({ creator_id: current_user.id, room_id: params[:room_id] })
    end
end
