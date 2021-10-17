class MembersController < ApplicationController
    before_action :set_product, only: %i[show update destroy]
    
    def index
        render json: Member.all
    end

    def show
        render json: @member
    end

    def create
        current_club = Club.find(params[:club_id])
        member = current_club.members.build(member_params)
        if member.save
            render json: member, status: :created
        else
            render json: { errors: member.errors }, status:
            :unprocessable_entity
        end
    end

    def update
        if @member.update(member_params)
            render json: @member
        else
            render json: @member.errors, status:
            :unprocessable_entity
        end
    end

    def destroy
        @member.destroy
        head 204
    end
    
    private

    def member_params
        params.require(:member).permit(:first_name, :last_name, :email)
        end

    def set_member
        @member = Member.find(params[:id])
    end
    
    
end
