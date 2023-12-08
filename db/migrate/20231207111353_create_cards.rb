class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.integer :bonuses
      t.references :user
      t.references :shop
      t.timestamps
    end
  end
end
