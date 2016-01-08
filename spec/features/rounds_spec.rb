require 'rails_helper'

describe "RoundsPages" do

	describe "show all rounds of a tournament match" do 
    let (:tournament) { FactoryGirl.create(:tournament) }
    let (:tournament_match) { FactoryGirl.create(:tournament_match, manager: tournament) }
    let (:tournament_match_2) { FactoryGirl.create(:tournament_match, manager: tournament) }
    let (:contest) { FactoryGirl.create(:contest) }
		let (:contest_match) { FactoryGirl.create(:contest_match, manager: contest) }

    before do
      5.times { FactoryGirl.create(:round, match: tournament_match) }
      5.times { FactoryGirl.create(:round, match: tournament_match_2) }
      5.times { FactoryGirl.create(:round, match: contest_match) }
			visit match_rounds_path(:tournament_match)
		end

		it "lists all the rounds for the match" do
			Rounds.where(match: tournament_match).each do |r|
				should have_selector('li', text: r.id)	
        should have_link(r.id, round_path(r))
			end
		end

		it "should not list rounds of a different match" do
			Rounds.where(match: tournament_match_2).each do |r|
				should_not have_selector('li', text: r.id)	
        should_not have_link(r.id, round_path(r))
			end
			Rounds.where(match: contest_match).each do |r|
				should_not have_selector('li', text: r.id)	
        should_not have_link(r.id, round_path(r))
			end
		end
	end

	describe "show all rounds of a contest match" do 
    let (:tournament) { FactoryGirl.create(:tournament) }
    let (:tournament_match) { FactoryGirl.create(:tournament_match, manager: tournament) }
    let (:contest) { FactoryGirl.create(:contest) }
		let (:contest_match) { FactoryGirl.create(:contest_match, manager: contest) }
		let (:contest_match_2) { FactoryGirl.create(:contest_match, manager: contest) }

    before do
      5.times { FactoryGirl.create(:round, match: tournament_match) }
      5.times { FactoryGirl.create(:round, match: contest_match) }
      5.times { FactoryGirl.create(:round, match: contest_match_2) }
			visit match_rounds_path(:contest_match)
		end

		it "lists all the rounds for the match" do
			Rounds.where(match: contest_match).each do |r|
				should have_selector('li', text: r.id)	
        should have_link(r.id, round_path(r))
			end
		end

		it "should not list rounds of a different match" do
			Rounds.where(match: contest_match_2).each do |r|
				should_not have_selector('li', text: r.id)	
        should_not have_link(r.id, round_path(r))
			end
			Rounds.where(match: tournament_match).each do |r|
				should_not have_selector('li', text: r.id)	
        should_not have_link(r.id, round_path(r))
			end
		end
	end

end