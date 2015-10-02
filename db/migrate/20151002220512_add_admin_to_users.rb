class AddAdminToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :users, :admin, required: true, default: false, index: true
    end
  end
end
