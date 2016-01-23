require 'rails_helper'

feature "HomePage" do
=begin
  let(:user) { FactoryGirl.create(:user) }
  let!(:challenge_match) { FactoryGirl.create(:challenge_match) }
  let!(:tournament_match) { FactoryGirl.create(:tournament_match) }

  before do 
    login user
		visit root_path 
	end
  subject { page }
=end

	describe "in the dashboard, test that the appropriate matches are shown, and that other matches are not shown" do
		it "is a pending number of tests"
	end
end
