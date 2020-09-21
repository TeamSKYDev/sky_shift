class StoresController < ApplicationController
    def new
        @store = Store.new
    end

    def create
        @store = Store.new(store_params)
        @store.creator_id = current_user.id
        respond_to do |format|
            if @store.save
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
    end
    
    private
    def store_params
        params.require(:store).permit(:name)
    end
end
