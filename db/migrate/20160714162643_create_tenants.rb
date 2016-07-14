class CreateTenants < ActiveRecord::Migration
  def change
    create_table :tenants do |t|
      t.string :name
      t.string :email
      t.string :phone_number
      t.boolean :active?
      t.references :apartment
      t.timestamps
    end
  end
end
