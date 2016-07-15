class TenantStatusChange < ActiveRecord::Migration
  def self.up
    change_column :tenants, :active, :string
  end

  def self.down
    change_column :tenant, :active, :boolean
  end
end
