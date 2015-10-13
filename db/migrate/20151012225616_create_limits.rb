class CreateLimits < ActiveRecord::Migration
  def change
    create_table :limits do |t|
      t.belongs_to :package, required: true,
        foreign_key: { on_delete: :cascade }
      t.belongs_to :activity_type, required: true,
        foreign_key: { on_delete: :cascade }
      t.integer :maximum, required: true, default: 0
    end

    add_index :limits, [:package_id, :activity_type_id], unique: true
  end
end
