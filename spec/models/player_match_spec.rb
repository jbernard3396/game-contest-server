require 'rails_helper'

describe PlayerMatch do
  let (:player_match) { FactoryGirl.create(:player_match) }
  subject { player_match }

  # Tables
  it { should respond_to(:player) }
  it { should respond_to(:match) }

  # Attributes
  it { should respond_to(:result) }

  describe "validations" do
    it { should be_valid }
    specify { expect_required_attribute(:player) }
    specify { expect_required_attribute(:match) }
  end

	describe "result is (case-sensitive)" do
		let (:list) { [nil, 'Win', 'Loss', 'Tie', 'Unknown Result'] }
		it "in the list [nil, 'Win', 'Loss', 'Tie', 'Unknown Result']" do
			list.each do |list_item|
				player_match.result = list_item
    		should be_valid 
			end
		end

		it "not in the list [nil, 'Win', 'Loss', 'Tie', 'Unknown Result']" do
			player_match.result = 'garbage'
    	should_not be_valid
		end
=begin
		describe "'Win'" do
			before do
				player_match.result = 'Win'
			end
    	it { should be_valid }
		end

		describe "'win'" do
			before do
				player_match.result = 'win'
			end
    	it { should_not be_valid }
		end

		describe "'Loss'" do
			before do
				player_match.result = 'Loss'
			end
    	it { should be_valid }
		end

		describe "'loss'" do
			before do
				player_match.result = 'loss'
			end
    	it { should_not be_valid }
		end
=end

	end

end
