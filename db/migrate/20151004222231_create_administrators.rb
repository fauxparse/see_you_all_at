class CreateAdministrators < ActiveRecord::Migration
  def change
    create_table :administrators do |t|
      t.belongs_to :event, required: true, foreign_key: { on_delete: :cascade }
      t.belongs_to :user, required: true, foreign_key: { on_delete: :cascade }
      t.timestamps null: false
    end

    add_index :administrators, [:event_id, :user_id], unique: true
    add_index :administrators, [:user_id]
  end
end
