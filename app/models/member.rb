class Member < ApplicationRecord
    belongs_to :club
    after_initialize :init

    def init
      self.games_played = 0          
    end
end
