class ClubsController < ApplicationController
    def index
        render json: Club.all
    end

    def show
        render json: Club.find(params[:id])
    end
end
