class CreateCarSpaces < ActiveRecord::Migration
  def change
    create_table :car_spaces do |t|
      t.references :apartment
      t.timestamps
    end
  end
end
