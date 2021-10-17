class ClubsController < ApplicationController
    def index
        render json: Club.all
    end

    def show
        render json: Club.find(params[:id])
    end

    def result_draw
        higher_ranked_player = Member.find(params[:higher_id])
        lower_ranked_player = Member.find(params[:lower_id])
        if (higher_ranked_player.current_rank - lower_ranked_player.current_rank).abs == 1
            render json: { message: "Result Captured. No Change in standings!"}
        else
            old_rank = lower_ranked_player.current_rank
            members_moving_down = Member.where('current_rank > ?',old_rank-1)
            members_moving_down.delete_at(1)
            members_moving_down.each do |mem|
                mem.current_rank += 1
                mem.save
            end
            lower_ranked_player.current_rank -= 1
            lower_ranked_player.save
            render json: { message: "Result Captured. Standings have changed!"}
        end
            
    
    end

    def result_win
        winning_player = Member.find(params[:winning_id])
        losing_player = Member.find(params[:losing_id])
        if winning_player.current_rank < losing_player.current_rank
            render json: { message: "Result Captured. No Change in standings!"}
        else
            if (winning_player.current_rank - losing_player.current_rank).abs == 1
                winning_player.current_rank -=1
                losing_player.current_rank +=1
                winning_player.save
                losing_player.save
                render json: { message: "Result Captured. Standings have changed!"}
            else
                losers_rank = losing_player.current_rank
                loser_switching_member = Member.where('current_rank = ?',losers_rank+1)
                loser_switching_member.current_rank -=1
                losing_player.current_rank +=1
                loser_switching_member.save
                losing_player.save

                pos_to_move_up =  winning_player.current_rank - losers_rank / 2
                lower_ranked_players = Member.scoped(:conditions => {:current_rank => pos_to_move_up..winning_player.current_rank})
                lower_ranked_players.each do |mem|
                    mem.current_rank += 1
                    mem.save
                end
                winning_player.current_rank -=pos_to_move_up
                winning_player.save
                render json: { message: "Result Captured. Standings have changed!"}
            end
    end
end
