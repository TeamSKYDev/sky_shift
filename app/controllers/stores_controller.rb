class StoresController < ApplicationController
    def new
        @store = Store.new
    end

    def create
        @store = Store.new(store_params)
        @store.creator_id = current_user.id
        @store.uuid = SecureRandom.alphanumeric(15)
        loop do
          if Store.where(uuid: @store.uuid).present?
            @store.uuid = SecureRandom.alphanumeric(15)
          else
            break
          end
        end

        # 店舗チャットのルーム設定はこちらへ

        respond_to do |format|
            if @store.save
                staff = Staff.new
                staff.user_id = current_user.id
                staff.store_id = @store.id
                staff.is_admin = true
                staff.is_permitted_status = true
                staff.save!
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

    def show
        @store = Store.find(params[:id])
        @unrelated_staffs = Staff.where(is_permitted_status: false)
        current_user.update(selected_store: params[:id])
    end

    private
    def store_params
        params.require(:store).permit(:name)
    end
end
