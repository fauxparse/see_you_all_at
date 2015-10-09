class CreateActivityTypes < ActiveRecord::Migration
  def change
    create_table :activity_types do |t|
      t.belongs_to :event, required: true, foreign_key: { on_delete: :cascade }
      t.string :name, required: true
      t.string :slug, required: true
      t.integer :position, required: true, default: 0
    end

    add_index :activity_types, [:event_id, :slug], unique: true
  end
end
