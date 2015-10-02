class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.references :user, index: true, foreign_key: { on_delete: :cascade }
      t.string :provider, required: true
      t.string :uid, required: true

      t.timestamps null: false
    end
  end
end
