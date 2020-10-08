class Api::V1::PrivateSchedulesController < ApiController
  
    # ActiveRecordのレコードが見つからなければ404 not foundを応答する
    rescue_from ActiveRecord::RecordNotFound do |exception|
      render json: { error: '404 not found' }, status: 404
    end
  
    def index
      private_schedules = PrivateSchedule.all
      render json: private_schedules
    end
  
    def show
      render json: @store
    end
  

end