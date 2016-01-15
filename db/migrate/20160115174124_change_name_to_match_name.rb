class ChangeNameToMatchName < ActiveRecord::Migration
  def change
		rename_column :matches, :name, :match_name
  end
end
