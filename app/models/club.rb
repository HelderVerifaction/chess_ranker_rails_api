class Club < ApplicationRecord
    has_many :members ,dependent: :destroy
end
