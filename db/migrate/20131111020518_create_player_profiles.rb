class CreatePlayerProfiles < ActiveRecord::Migration
  def change
    create_table :player_profiles do |t|
      t.integer :batting_power
      t.integer :batting_contact
      t.integer :pitching
      t.references :player, index: true

      t.timestamps
    end
  end
end
