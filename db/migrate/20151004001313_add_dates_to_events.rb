class AddDatesToEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.date :starts_on, required: true
      t.date :ends_on, required: true
      t.string :time_zone, required: true, default: Time.zone.name
    end
  end
end
