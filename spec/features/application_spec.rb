require 'rails_helper'

feature "HomePage" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let!(:challenge_match) { FactoryGirl.create(:challenge_match) }
  let!(:tournament_match) { FactoryGirl.create(:tournament_match) }

  before do 
    login user
		visit root_path 
	end


end
