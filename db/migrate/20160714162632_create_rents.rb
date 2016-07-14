class CreateRents < ActiveRecord::Migration
  def change
    create_table :rents do |t|
      t.float :amount
      t.date :month
      t.string :pay_status
      t.references :apartment
      t.references :tenant
      t.timestamps
    end
  end
end
