class Api::V1::StoresController < ApiController
    before_action :set_store, only: [:show]
  
    # ActiveRecordのレコードが見つからなければ404 not foundを応答する
    rescue_from ActiveRecord::RecordNotFound do |exception|
      render json: { error: '404 not found' }, status: 404
    end
  
    def index
      stores = Store.all
      render json: stores
    end
  
    def show
      render json: @store
    end
  
    private
  
    def set_store
        @store = Store.find(params[:id])
    end
end