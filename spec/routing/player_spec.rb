require 'rails_helper'

describe Player do
    describe "available routes" do
        describe "within contest" do
            specify { expect(get(contest_players_path(1))).to be_routable }
        end

        describe "non-nested" do
            specify { expect(post(players_path(1))).to be_routable }
            specify { expect(get(new_player_path(1))).to be_routable }
            specify { expect(get(edit_player_path(1))).to be_routable }
            specify { expect(get(player_path(1))).to be_routable }
            specify { expect(patch(player_path(1))).to be_routable }
            specify { expect(delete(player_path(1))).to be_routable }
        end

        describe "unavailable routes" do
            specify { expect(get(players_path(1))).not_to be_routable }
        end
    end
end
