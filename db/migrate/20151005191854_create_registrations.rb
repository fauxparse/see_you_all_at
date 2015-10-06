class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.belongs_to :event, required: true, foreign_key: { on_delete: :cascade }
      t.belongs_to :package, required: true,
        foreign_key: { on_delete: :cascade }
      t.belongs_to :user, required: true, foreign_key: { on_delete: :cascade }
      t.timestamps null: false
    end

    add_index :registrations, [:package_id, :user_id]
  end
end
