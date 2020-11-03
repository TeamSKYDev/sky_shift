class StoresController < ApplicationController
    before_action :check_selected_store, except: [:new, :create, :show]


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
                # メインルームの作成
                room = current_user.rooms.build(name: "All", store_id: @store.id)
                current_user.save
                
                # 店舗にメインルームIDを設定
                @store.update(main_room_id: room.id)
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
        @title = @store.name + "詳細"
        @staff = Staff.find_by(user_id: current_user.id, store_id: @store.id)
        if @staff.blank? || @staff.is_permitted_status == false
            redirect_to home_path
        end
        @unrelated_staffs = Staff.where(is_permitted_status: false, store_id: @store.id)
        
    end

    def edit
        @store = Store.find(params[:id])
        @title = @store.name
        @creator = User.find_by(id: @store.creator_id)

        @staff = Staff.find_by(user_id: current_user.id, store_id: @store.id)
        if @staff.blank? || @staff.is_permitted_status == false || @staff.is_admin == false
            redirect_to home_path
        end
    end

    def update
        @store = Store.find(params[:id])
        if @store.update(store_params)
            flash[:notice] = "store update successfully"
        else
            flash[:notice] = "cannot update"
        end
        redirect_to store_path(@store)
    end

    def destroy
        @store = Store.find(params[:id])
        store_name = @store.name
        @store.destroy
        flash[:notice] = "dastroy #{store_name}"
        redirect_to home_path
    end

    private
    def store_params
        params.require(:store).permit(:name)
    end
end
