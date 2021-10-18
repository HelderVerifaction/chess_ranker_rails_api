class MembersController < ApplicationController
    before_action :set_member, only: %i[show update destroy]
    
    def index
        render json: Member.all.order("current_rank ASC")
    end

    def show
        render json: @member
    end

    def create
        current_club = Club.find(params[:club_id])
        new_member = current_club.members.build(member_params)
        new_member.games_played = 0
        new_member.current_rank = current_club.members.count+1
        if new_member.save
            render json: new_member, status: :created
        else
            render json: { errors: new_member.errors }, status:
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
        members_to_move_up = Member.where('current_rank > ?',@member.current_rank)
        members_to_move_up.each do |mem|
            mem.current_rank -= 1
            mem.save
        end
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
