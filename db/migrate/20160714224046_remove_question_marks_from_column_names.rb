class RemoveQuestionMarksFromColumnNames < ActiveRecord::Migration

  def self.up
    rename_column :notes, :outstanding?, :outstanding
    rename_column :tenants, :active?, :active
  end

  def self.down
    rename_column :notes, :outstanding, :outstanding?
    rename_column :tenants, :active, :active?
  end

end
