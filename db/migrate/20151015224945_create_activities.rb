class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.belongs_to :activity_type, required: true,
        foreign_key: { on_delete: :cascade}
      t.string :name, required: true
      t.string :slug, required: true
      t.text :description
      t.timestamps null: false
    end

    add_index :activities, [:activity_type_id, :slug], unique: true
  end
end
