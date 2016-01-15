class Round < ActiveRecord::Base
  belongs_to :match

  
  has_many :player_rounds, dependent: :destroy
  has_many :players,  through: :player_rounds
	
	#validates :players, presence: true
  
  validates :match, presence: true

	validate	:check_num_rounds

  def name
    return SecureRandom.hex(5)
  end

	def check_num_rounds
		unless self.match.nil?
			rounds = Round.where(match_id: self.match_id).count
			num_rounds = Match.find(self.match_id).num_rounds
#			puts rounds<=num_rounds
			if rounds > num_rounds	
				errors.add(:count, "you have more rounds than this match allows")
			end
		end
	end
      
  extend FriendlyId
  friendly_id :name, use: :slugged


	validate :same_players_as_match 

	def same_players_as_match
		#if match.present? && match.players != players # this line will accomplish what the line below accomplishes, and also accomplishes the 'validates :players....' line above
		if match.present? && players.present? && match.players != players
			errors.add(:players, "must be the same as the match's players")
		end
	end
end
