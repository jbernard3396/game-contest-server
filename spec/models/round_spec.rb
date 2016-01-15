require 'rails_helper'

describe Round do
  let (:round) { FactoryGirl.create(:challenge_round) }
  subject { round }

  # Tables
  it { should respond_to(:match) }
	it { should respond_to(:player_rounds) }
	it { should respond_to(:players) }

	describe "validations" do 
    it { should be_valid }
		specify { expect_required_attribute(:match) }
	end

	describe "does not have the same players as the match" do
		before do
=begin
			puts 'round.match.players'
			puts_players round.match.players
			puts 'round.players'
			puts_players round.players
=end
			round.match.players.destroy(round.match.players.first)
			round.match.players.reload
			round.players.reload
			player1 = FactoryGirl.create(:player)
			player_match1 = FactoryGirl.create(:player_match, player: player1, match: round.match)
			player1.save	
			player_match1.save
			round.match.players.reload
			round.players.reload
		end
    it { should_not be_valid }
	end

	describe "is created if there are already num_round rounds for that match" do
		before do
			match = FactoryGirl.create(:tournament_match, num_rounds: 5)
			FactoryGirl.create_list(:tournament_round, 5, match: match)
			match.rounds << round
		end

		it { should_not be_valid }
	end
end
