class AddRoundNameToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :round_name, :string
  end
end
