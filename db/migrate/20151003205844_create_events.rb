class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name, required: true
      t.string :slug, required: true
      t.datetime :starts_at, required: true
      t.datetime :stops_at, required: true

      t.timestamps null: false
    end

    add_index :events, :slug, unique: true
    add_index :events, [:starts_at, :stops_at]
  end
end
