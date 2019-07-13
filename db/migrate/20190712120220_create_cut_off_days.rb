class CreateCutOffDays < ActiveRecord::Migration[5.2]
  def change
    create_table :cut_off_days do |t|
      t.string :uuid
      t.text :data

      t.timestamps
    end
  end
end
