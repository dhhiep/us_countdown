class CreateRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :records do |t|
      t.string :name
      t.string :imm_type
      t.datetime :priority_date
      t.datetime :approval_date

      t.timestamps
    end
  end
end
