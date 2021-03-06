require 'rails_helper'

include ActionView::Helpers::DateHelper

describe "ContestsPages" do
  let (:creator) { FactoryBot.create(:contest_creator) }
  let!(:referee) { FactoryBot.create(:referee) }
  let (:now) { mins_multiple_of_5(1.hour.from_now) }
  let (:name) { 'Test Contest' }
  let (:description) { 'Contest description' }

  subject { page }

  describe "create" do
    let (:submit) { 'Create Contest' }

    before do
      login creator
      visit new_contest_path
    end

    it { should have_selector("h2", "Add Contest") }                 

    describe "invalid information" do
      describe "missing information" do
        it "should not create a contest" do
          expect { click_button submit }.not_to change(Contest, :count)
        end

        describe "after submission" do
          before { click_button submit }

          it { should have_alert(:danger) }
        end
      end

      illegal_dates.each do |date|
        describe "illegal date (#{date.to_s})" do
          before do
            select_illegal_datetime('Deadline', date)
            fill_in 'Description', with: description
            fill_in 'Name', with: name
            select referee.name, from: 'Referee'
            click_button submit
          end

          it { should have_alert(:danger) }
        end
      end
    end

    describe "valid information" do
      before do
        select_datetime(now, 'Deadline')
        fill_in 'Description', with: description
        fill_in 'Name', with: name
        select referee.name, from: 'Referee'
      end
      
      it "should create a contest" do
        expect { click_button submit }.to change(Contest, :count).by(1)
      end

      describe "redirects properly", type: :request do
        before do
          login creator, avoid_capybara: true
          post contests_path, params: { contest: { deadline: now.strftime("%F %T"),
            description: description,
            name: name,
            referee_id: referee.id } }
        end

        specify { expect(response).to redirect_to(contest_path(assigns(:contest))) }
      end

      describe "after submission" do
        let (:contest) { Contest.find_by(name: name) }

        before { click_button submit }

        specify { expect(contest.user).to eq(creator) }

        it { should have_alert(:success, text: 'Contest created') }
        it { should have_content(/About 1 Hour/) }
        it { should have_content(description) }
        it { should have_content(name) }
        it { should have_content(contest.referee.name) }
        it { should have_link('',
          href: new_contest_player_path(contest)) }
      end
    end
  end

  describe "edit" do
    let (:contest) { FactoryBot.create(:contest, user: creator, deadline: now) }
    let!(:orig_name) { contest.name }
    let (:submit) { 'Update Contest' }

    before do
      login creator
      visit edit_contest_path(contest)
    end

    it { should have_selector("h2", "Edit Contest") }                 
    it { expect_datetime_select(contest.deadline, 'Deadline') }
    it { should have_field('Description', with: contest.description) }
    it { should have_field('Name', with: contest.name) }
    it { should have_content( contest.referee.name) }

    describe "with invalid information" do
      before do
        select_datetime(now, 'Deadline')
        fill_in 'Name', with: ''
        fill_in 'Description', with: description
      end

      describe "does not change data" do
        before { click_button submit }

        specify { expect(contest.reload.name).not_to eq('') }
        specify { expect(contest.reload.name).to eq(orig_name) }
      end

      it "does not add a new contest to the system" do
        expect { click_button submit }.not_to change(Contest, :count)
      end

      it "produces an error message" do
        click_button submit
        should have_alert(:danger)
      end
    end

    describe "with valid information" do
      before do
        select_datetime(now, 'Deadline')
        fill_in 'Name', with: name
        fill_in 'Description', with: description
      end

      describe "changes the data" do
        before { click_button submit }

        it { should have_alert(:success) }
        specify { expect_same_minute(contest.reload.deadline, now) }
        specify { expect(contest.reload.name).to eq(name) }
        specify { expect(contest.reload.description).to eq(description) }
        it { should have_link('', href: new_contest_player_path(contest)) }
      end

      describe "redirects properly", type: :request do
        before do
          login creator, avoid_capybara: true
          patch contest_path(contest), params: { contest: { deadline: now.strftime("%F %T"),
            description: description,
            name: name,
            referee_id: referee.id } }
        end

        specify { expect(response).to redirect_to(contest_path(contest)) }
      end

      it "does not add a new contest to the system" do
        expect { click_button submit }.not_to change(Contest, :count)
      end
    end
  end

  describe "destroy", type: :request do
    let!(:contest) { FactoryBot.create(:contest, user: creator) }

    before do
      login creator, avoid_capybara: true
    end

    describe "redirects properly" do
      before { delete contest_path(contest) }

      specify { expect(response).to redirect_to(contests_path) }
    end

    it "produces a delete message" do
      delete contest_path(contest)
      get response.location
      response.body.should have_alert(:success)
    end

    it "removes a contest from the system" do
      expect { delete contest_path(contest) }.to change(Contest, :count).by(-1)
    end
  end

  describe "pagination" do
    let (:contest) { FactoryBot.create(:contest) }
    before do
    30.times { FactoryBot.create(:contest) }

    visit contests_path
    end
    it { should have_content('10 Contests') }
    it { should have_selector('div.pagination') }
    it { should have_link('2', href: "/contests?page=2" ) }
    it { should have_link('3', href: "/contests?page=3") }
    it { should_not have_link('4', href: "/contests?page=4") }
  end

  describe 'search_error'do
    let(:submit) {"Search"}
    before do
      FactoryBot.create(:contest, name: "searchtest1")
      FactoryBot.create(:contest, name: "peter1")

      visit contests_path
      fill_in 'search', with:':'
      click_button submit
    end
      after(:all)  { User.delete_all }
    it { should have_content("0 Contests") }
    it { should_not have_link('2') }#, href: "/contests?utf8=✓&direction=&sort=&search=searchtest4&commit=Search" ) }
    it {should have_alert(:info) }
  end



   describe 'search_partial' do
    let(:submit) {"Search"}
    before do
      FactoryBot.create(:contest, name: "searchtest1")
      FactoryBot.create(:contest, name: "peter1")
      FactoryBot.create(:contest, name: "searchtest2")
      FactoryBot.create(:contest, name: "peter2")
      FactoryBot.create(:contest, name: "searchtest9")
      FactoryBot.create(:contest, name: "peter9")
      FactoryBot.create(:contest, name: "searchtest4")
      FactoryBot.create(:contest, name: "peter4")
      FactoryBot.create(:contest, name: "searchtest5")
      FactoryBot.create(:contest, name: "peter5")
      FactoryBot.create(:contest, name: "searchtest6")
      FactoryBot.create(:contest, name: "peter6")
      FactoryBot.create(:contest, name: "searchtest7")
      FactoryBot.create(:contest, name: "peter7")
      FactoryBot.create(:contest, name: "searchtest8")
      FactoryBot.create(:contest, name: "peter8")
      visit contests_path
      fill_in 'search', with:'te'
      click_button submit
    end
    after(:all)  { User.delete_all }
     it { should have_content("10 Contests") }
    it { should have_link('2') }
    it { should_not have_link('3') }
   # it { should_not have_link('3', href: "/contests?utf8=✓&direction=&sort=&search=te&commit=Search") }
  end

  describe 'search_pagination' do
    let(:submit) {"Search"}
    before do
      FactoryBot.create(:contest, name: "searchtest1")
      FactoryBot.create(:contest, name: "peter1")
      FactoryBot.create(:contest, name: "searchtest2")
      FactoryBot.create(:contest, name: "peter2")
      FactoryBot.create(:contest, name: "searchtest3")
      FactoryBot.create(:contest, name: "peter3")
      FactoryBot.create(:contest, name: "searchtest4")
      FactoryBot.create(:contest, name: "peter4")
      FactoryBot.create(:contest, name: "searchtest5")
      FactoryBot.create(:contest, name: "peter5")
      FactoryBot.create(:contest, name: "searchtest6")
      FactoryBot.create(:contest, name: "peter6")
      visit contests_path
      fill_in 'search', with:'searchtest4'
      click_button submit
    end
    after(:all)  { User.delete_all }
    it { should have_content("1 Contest") }
    it { should_not have_link('2') }#, href: "/contests?utf8=✓&direction=&sort=&search=searchtest4&commit=Search" ) }
  end

  describe 'search' do
    let(:submit) {"Search"}

    before do
      FactoryBot.create(:contest, name: "searchtest")
      visit contests_path
      fill_in 'search', with:'searchtest'
      click_button submit
    end

    it 'should return results' do
      should have_button('searchtest')
      should have_content('1 Contest')
    end

   end

  describe "show" do
    let (:contest) { FactoryBot.create(:contest, user: creator) }

    describe "as any user" do
      before { visit contest_path(contest) }

      it { should have_selector("h2", "Contest") }      
      it { should have_content(contest.name) }
      it { should have_content(contest.description) }
      it { should have_content(distance_of_time_in_words_to_now(contest.deadline).split.map { |i| i.capitalize }.join(' ')) }
      it { should have_content(contest.user.username) }
      it { should have_link(contest.user.username, user_path(contest.user)) }
      it { should have_content(contest.referee.name) }
      it { should have_link(contest.referee.name, referee_path(contest.referee)) }

      it "lists all the players in the contest" do
        Player.where(contest: contest).each do |player|
          should have_selector('li', text: player.name)
          should have_link(t.name, player_path(player))
        end
      end

      it { should_not have_link('',
        href: new_contest_player_path(contest)) }

      it { should have_link('',
        href: new_contest_match_path(contest)) }
    end

    describe "as contest_creator" do
      before do 
        login creator
        visit contest_path(contest)
      end

      it { should have_selector("h2", "Contest") }      
      it { should have_content(contest.name) }
      it { should have_content(contest.description) }
      it { should have_content(distance_of_time_in_words_to_now(contest.deadline).split.map { |i| i.capitalize }.join(' ')) }
      it { should have_content(contest.user.username) }
      it { should have_link(contest.user.username, user_path(contest.user)) }
      it { should have_content(contest.referee.name) }
      it { should have_link(contest.referee.name, referee_path(contest.referee)) }

      it "lists all the players in the contest" do
        Player.where(contest: contest).each do |player|
          should have_selector('li', text: player.name)
          should have_link(t.name, player_path(player))
        end
      end

      it { should have_link('',
        href: new_contest_player_path(contest)) }

      it { should have_link('',
        href: new_contest_match_path(contest)) }
    end
  
  end

  describe "show all as any user" do
    before do
      5.times { FactoryBot.create(:contest) }

      visit contests_path
    end

    it "does not have adding option" do
      should_not have_link('', href: new_contest_path)
    end

    it { should have_selector("h2", "Contest") }               

    it "lists all the contests in the system" do
      Contest.all.each do |c|
        should have_selector('input.results-container')
        should have_button(c.name, contest_path(c))
      end
    end
  end
  describe "show all as contest_creator" do
    before do
      login creator
      
      visit contests_path
    end

    it "has adding option" do
      should have_link('', href: new_contest_path)
    end

    it { should have_selector("h2", "Contest") }               
  end
end
