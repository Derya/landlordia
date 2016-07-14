class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :content
      t.string :type
      t.boolean :outstanding?
      t.references :apartment
      t.references :tenant
      t.timestamps
    end
  end
end
