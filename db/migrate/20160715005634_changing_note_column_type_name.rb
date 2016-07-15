class ChangingNoteColumnTypeName < ActiveRecord::Migration
  def self.up
    rename_column :notes, :type, :note_type
  end

  def self.down
    rename_column :notes, :note_type, :type
  end

end
