class RenameTableCutOffDays < ActiveRecord::Migration[5.2]
  def up
    rename_table :cut_off_days, :visa_bulletins
  end

  def down
    rename_table :visa_bulletins, :cut_off_days
  end
end
