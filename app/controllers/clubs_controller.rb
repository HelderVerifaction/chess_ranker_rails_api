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
        # higher_ranked_player.games_played = higher_ranked_player.games_played + 1
        # lower_ranked_player.games_played = lower_ranked_player.games_played + 1
        higher_ranked_player.games_played += 1
        lower_ranked_player.games_played +=  1
        if (higher_ranked_player.current_rank - lower_ranked_player.current_rank).abs == 1
            higher_ranked_player.save
            lower_ranked_player.save
            render json: { message: "Result Captured. No Change in standings!"}
        else
            old_rank = lower_ranked_player.current_rank
            members_moving_down = Member.where('current_rank >= ?',old_rank-1)
            members_moving_down.select{ |x| x.id !=lower_ranked_player.id }
            members_moving_down.each do |mem|
                mem.current_rank += 1
                mem.save
            end
            lower_ranked_player.current_rank -= 1
            higher_ranked_player.save
            lower_ranked_player.save
            render json: { message: "Result Captured. Standings have changed!"}
        end
            
    
    end

    def result_win
        winning_player = Member.find(params[:winning_id])
        losing_player = Member.find(params[:losing_id])
        winning_player.games_played +=1
        losing_player.games_played +=1
        if winning_player.current_rank < losing_player.current_rank
            winning_player.save
            losing_player.save
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
     
                loser_switching_member = Member.where('current_rank':(losers_rank+1)).first
                loser_switching_member.current_rank -=1
                loser_switching_member.save
                

                pos_to_move_up =  (winning_player.current_rank - losers_rank) / 2
                lower_ranked_players = Member.where('current_rank':(winning_player.current_rank - pos_to_move_up)..(winning_player.current_rank-1))

                lower_ranked_players.each do |mem|
                    mem.current_rank += 1
                    mem.save
                end
                winning_player.current_rank -=pos_to_move_up
                losing_player.current_rank +=1
                losing_player.save
                winning_player.save
                render json: { message: "Result Captured. Standings have changed!"}
            end
        end
    end
end
