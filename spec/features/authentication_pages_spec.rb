require 'rails_helper'

describe "AuthenticationPages" do
  subject { page }
  describe "login page" do
    before { visit login_path }

    it { should have_content('Log In') }

    describe "with invalid account" do
      before { click_button 'Log In' }

      it { should have_alert(:danger, text: 'Invalid') }

      describe "visiting another page" do
        before { click_link 'All Contests' }

        it { should_not have_alert(:danger) }
      end
    end

    describe "with valid account" do

			describe "as user" do
      	let(:user) { FactoryGirl.create(:user) }

      	before do
        	fill_in 'Username', with: user.username
        	fill_in 'Password', with: user.password
        	click_button 'Log In'
      	end
			
  			describe "the navigation bar" do
    			it { should have_selector('.navbar') }

    			it "has the proper links" do
      			within ".navbar" do
        			should have_link('Taylor Game Contest Server', href: root_path)
        			should have_link('Challenge Classmate', href: new_match_path)
        			should have_link('Upload Code', href: new_player_path)
        			should have_link('All Contests', href: contests_path)
        			should_not have_link('Log In', href: login_path)
        			should_not have_link('Sign Up', href: signup_path)
      				should have_link('Help', href: help_path) 
      				should have_selector(:xpath, "//li/a", text: 'Account') 
      				should have_link('Log Out', href: logout_path) 
      				should have_link('Profile', href: user_path(user)) 
      				should have_link('Settings', href: edit_user_path(user)) 
        			should_not have_selector(:xpath, "//li/a", text: 'Create a New...') 
        			should_not have_link('Contest', href: new_contest_path) 
        			should_not have_link('Referee') 
        			should_not have_link('Tournament') 
        			should_not have_link('Player') 
        			should_not have_selector(:xpath, "//li/a", text: 'Edit Existing...') 
        			should_not have_link('Referees') 
        			should_not have_link('Users') 
     				end
   				end
				end

      	it { should have_alert(:success) }

      	describe "followed by logout" do
        	before { click_link 'Log Out' }
  				describe "the navigation bar" do
    				it "has the proper links" do
      				within ".navbar" do
        				should have_button('Log In') 
        				should have_button('Sign Up') 
			        	should have_link('Taylor Game Contest Server') 
			        	should have_link('All Contests') 
			        	should have_link('Help') 
        				should_not have_selector(:xpath, "//li/a", text: 'Account') 
        				should_not have_link('Log Out', href: logout_path) 
        				should_not have_link('Settings') 
			        	should_not have_link('Profile') 
							end
						end
					end

        	it { should have_alert(:info) }
      	end
			end

		
			describe "as contest creator" do
      	let(:creator) { FactoryGirl.create(:contest_creator) }

      	before do
        	fill_in 'Username', with: creator.username
        	fill_in 'Password', with: creator.password
        	click_button 'Log In'
      	end
  			describe "the navigation bar" do
    			it "has the proper links" do
      			within ".navbar" do
			        should have_link('Taylor Game Contest Server') 
        			should have_link('Challenge Classmate', href: new_match_path)
        			should have_selector(:xpath, "//li/a", text: 'Create a New...') 
        			should have_link('Contest') 
        			should have_link('Referee') 
        			should have_link('Tournament') 
        			should have_link('Player') 
        			should have_selector(:xpath, "//li/a", text: 'Edit Existing...') 
        			should have_link('Contests') 
        			should have_link('Referees') 
        			should have_link('Users') 
						end
					end
				end
			end
    end
  end
end

describe "AuthorizationPages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  describe "non-authenticated users" do
    describe "for Users controller" do
      describe "edit action" do
        it_behaves_like "redirects to a login" do
          let (:path) { edit_user_path(user) }
          let (:method) { :patch }
          let (:http_path) { user_path(user) }
        end
      end

      describe "delete action" do
        it_behaves_like "redirects to a login", skip_browser: true do
          let (:user) { FactoryGirl.create(:user) }
          let (:method) { :delete }
          let (:http_path) { user_path(user) }
        end
      end
    end

    describe "for Referees controller" do
      describe "new action" do
        it_behaves_like "redirects to a login" do
          let (:path) { new_referee_path }
          let (:method) { :post }
          let (:http_path) { referees_path }
        end
      end

      describe "edit action" do
        it_behaves_like "redirects to a login" do
          let (:referee) { FactoryGirl.create(:referee) }
          let (:path) { edit_referee_path(referee) }
          let (:method) { :patch }
          let (:http_path) { referee_path(referee) }
        end
      end

      describe "delete action" do
        it_behaves_like "redirects to a login", skip_browser: true do
          let (:referee) { FactoryGirl.create(:referee) }
          let (:method) { :delete }
          let (:http_path) { referee_path(referee) }
        end
      end
    end

    describe "for Contests controller" do
      describe "new action" do
        it_behaves_like "redirects to a login" do
          let (:path) { new_contest_path }
          let (:method) { :post }
          let (:http_path) { contests_path }
        end
      end

      describe "edit action" do
        it_behaves_like "redirects to a login" do
          let (:contest) { FactoryGirl.create(:contest) }
          let (:path) { edit_contest_path(contest) }
          let (:method) { :patch }
          let (:http_path) { contest_path(contest) }
        end
      end

      describe "delete action" do
        it_behaves_like "redirects to a login", skip_browser: true do
          let (:contest) { FactoryGirl.create(:contest) }
          let (:method) { :delete }
          let (:http_path) { contest_path(contest) }
        end
      end
    end

    describe "for Players controller" do
      describe "new action" do
        it_behaves_like "redirects to a login" do
          let (:contest) { FactoryGirl.create(:contest) }
          let (:path) { new_player_path }
          let (:method) { :post }
          let (:http_path) { players_path }
        end
      end

      describe "edit action" do
        it_behaves_like "redirects to a login" do
          let (:player) { FactoryGirl.create(:player) }
          let (:path) { edit_player_path(player) }
          let (:method) { :patch }
          let (:http_path) { player_path(player) }
        end
      end

      describe "delete action" do
        it_behaves_like "redirects to a login", skip_browser: true do
          let (:player) { FactoryGirl.create(:player) }
          let (:method) { :delete }
          let (:http_path) { player_path(player) }
        end
      end
    end

		describe "for Matches controller" do
			describe "index action (with path 'contest_matches')" do
        it_behaves_like "redirects to a login" , browser_only: true do
          let (:contest) { FactoryGirl.create(:contest) }
          let (:path) { contest_matches_path(contest) }
				end
			end

			describe "show action (with a challenge match)" do
        it_behaves_like "redirects to a login" , browser_only: true do
          let (:challenge_match) { FactoryGirl.create(:challenge_match) }
          let (:path) { match_path(challenge_match) }
				end
			end
		end

		describe "for Rounds controller show action" do # written with an educated guess of what the path will be for rounds (but that route has not been generated yet)
			describe "(Rounds are of a challange match)" do 
        it_behaves_like "redirects to a login" , browser_only: true do
					let (:challenge_round) { FactoryGirl.create(:challenge_round) }
          let (:path) { round_path(challenge_round) } 
				end
			end

			describe "(Rounds are of a tournament match)" do 
        it_behaves_like "redirects to a login" , browser_only: true do
					let (:tournament_round) { FactoryGirl.create(:tournament_round) }
          let (:path) { round_path(tournament_round) }
				end
			end
		end
  end

  describe "authenticated users" do
    describe "for Users controller" do
      it_behaves_like "redirects to root" do
        let (:login_user) { user }
        let (:path) { new_user_path }
        let (:signature) { 'Sign Up' }
        let (:error_type) { :warning }
        let (:method) { :post }
        let (:http_path) { users_path }
      end

      it_behaves_like "redirects to root" do
        let (:login_user) { user }
        let (:path) { login_path }
        let (:signature) { 'Log In' }
        let (:error_type) { :warning }
        let (:method) { :post }
        let (:http_path) { users_path }
      end
    end
  end

  describe "authenticated, but wrong user" do
    describe "for Users controller" do
      it_behaves_like "redirects to root" do
        let (:other_user) { FactoryGirl.create(:user) }
        let (:login_user) { user }
        let (:path) { edit_user_path(other_user) }
        let (:signature) { 'Edit user' }
        let (:error_type) { :danger }
        let (:method) { :patch }
        let (:http_path) { user_path(other_user) }
      end
    end

    describe "for Referees controller" do
      it_behaves_like "redirects to root" do
        let (:login_user) { user }
        let (:path) { new_referee_path }
        let (:signature) { 'Create Referee' }
        let (:error_type) { :danger }
        let (:method) { :post }
        let (:http_path) { referees_path }
      end

      it_behaves_like "redirects to root" do
        let (:referee) { FactoryGirl.create(:referee) }
        let (:login_user) { user }
        let (:path) { edit_referee_path(referee) }
        let (:signature) { 'Edit Referee' }
        let (:error_type) { :danger }
        let (:method) { :patch }
        let (:http_path) { referee_path(referee) }
      end

      it_behaves_like "redirects to root", skip_browser: true do
        let (:referee) { FactoryGirl.create(:referee) }
        let (:login_user) { user }
        let (:error_type) { :danger }
        let (:method) { :delete }
        let (:http_path) { referee_path(referee) }
      end
    end

    describe "for Contests controller" do
      it_behaves_like "redirects to root" do
        let (:login_user) { user }
        let (:path) { new_contest_path }
        let (:signature) { 'Create Contest' }
        let (:error_type) { :danger }
        let (:method) { :post }
        let (:http_path) { contests_path }
      end

      it_behaves_like "redirects to root" do
        let (:contest) { FactoryGirl.create(:contest) }
        let (:login_user) { user }
        let (:path) { edit_contest_path(contest) }
        let (:signature) { 'Edit Contest' }
        let (:error_type) { :danger }
        let (:method) { :patch }
        let (:http_path) { contest_path(contest) }
      end

      it_behaves_like "redirects to root", skip_browser: true do
        let (:contest) { FactoryGirl.create(:contest) }
        let (:login_user) { user }
        let (:error_type) { :danger }
        let (:method) { :delete }
        let (:http_path) { contest_path(contest) }
      end
    end

    describe "for Players controller" do
      it_behaves_like "redirects to root" do
        let (:player) { FactoryGirl.create(:player) }
        let (:login_user) { user }
        let (:path) { edit_player_path(player) }
        let (:signature) { 'Edit Player' }
        let (:error_type) { :danger }
        let (:method) { :patch }
        let (:http_path) { player_path(player) }
      end

      it_behaves_like "redirects to root", skip_browser: true do
        let (:player) { FactoryGirl.create(:player) }
        let (:login_user) { user }
        let (:error_type) { :danger }
        let (:method) { :delete }
        let (:http_path) { player_path(player) }
      end
    end

		describe "for Matches controller" do
			let (:challenge_match) { FactoryGirl.create(:challenge_match) }
      let (:other_user) { FactoryGirl.create(:user) }
      let (:login_user) { other_user }
			describe "index action (with a challenge match)" do
        it_behaves_like "redirects to root" , browser_only: true do
        	let (:signature) { 'Matches for' }
        	let (:error_type) { :danger }
          let (:path) { contest_matches_path(challenge_match.manager) }
				end
			end

			describe "show action (with a challenge match)" do
        it_behaves_like "redirects to root" , browser_only: true do
        	let (:signature) { 'Match Information' }
        	let (:error_type) { :danger }
          let (:path) { match_path(challenge_match) }
				end
			end
		end

		describe "for Rounds controller show action" do # written with an educated guess of what the path will be for rounds (but that route has not been generated yet)
      let! (:other_user) { FactoryGirl.create(:user) }
      let (:login_user) { other_user }
      let (:signature) { 'Round Information' }
      let (:error_type) { :danger }

			describe "(Rounds are of a challange match)" do 
        it_behaves_like "redirects to root" , browser_only: true do
					let (:challenge_round) { FactoryGirl.create(:challenge_round) }
          let (:path) { round_path(challenge_round) }
				end
			end

			describe "(Rounds are of a tournament match)" do 
        it_behaves_like "redirects to root" , browser_only: true do
					let (:tournament_round) { FactoryGirl.create(:tournament_round) }
          let (:path) { round_path(tournament_round) }
				end
			end
		end
		
  end
	
	describe "authenticated, but the action is not authorized at this time" do
		describe "for Players controller" do
      let (:login_user) { user }
      let (:signature) { 'New Player' }
      let (:error_type) { :danger }

			describe "new action, all contests have expired deadlines" do
      	it_behaves_like "redirects to root", browser_only: true do
     	  	let (:path) { new_player_path }
				end
			end

			describe "create action, selected contest's deadline has expired", skip_browser: true do
				let (:expired_contest) { FactoryGirl.create(:expired_contest) }
      	it_behaves_like "redirects to root", skip_browser: true do
       		let (:http_path) { players_path }
       		let (:method) { :post }
   #       let (:params) { ... }
				end
				# test not finished
			end
		end
	end

  describe "authenticated, but non-admin user" do
    describe "for Users controller" do
      it_behaves_like "redirects to root", skip_browser: true do
        let (:other_user) { FactoryGirl.create(:user) }
        let (:login_user) { user }
        let (:error_type) { :danger }
        let (:method) { :delete }
        let (:http_path) { user_path(other_user) }
      end
    end
  end

  describe "authenticated admin user" do
    let(:admin) { FactoryGirl.create(:admin) }

    describe "delete action (self)" do
      it_behaves_like "redirects to root", skip_browser: true do
        let (:login_user) { admin }
        let (:error_type) { :danger }
        let (:method) { :delete }
        let (:http_path) { user_path(admin) }
      end
    end
  end
end
