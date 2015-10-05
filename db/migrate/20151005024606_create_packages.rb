class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.belongs_to :event, required: true, foreign_key: { on_delete: :cascade }
      t.string :name, required: true
      t.string :slug, required: true
      t.integer :position
      t.timestamps null: false
    end

    add_index :packages, [:event_id, :slug], unique: true
    add_index :packages, [:event_id, :id], unique: true
  end
end
