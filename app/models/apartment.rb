class Apartment < ActiveRecord::Base
  has_many :tenants
  has_many :rents
  has_many :notes
  has_many :car_spaces
  validates :apartment_number, presence: true
  validate :lease_times
  validate :at_most_one_tenant_active

  def tenant_name
    if self.tenant
      self.tenant.name
    else
      "unoccupied"
    end
  end

  def tenant
    self.tenants.find_by(active: true)
  end

  private

  def lease_times
    errors.add(:base,"lease start must be before lease end") if lease_start && lease_end && lease_start > lease_end
  end

  def at_most_one_tenant_active
    errors.add(:base,"can have at most 1 active tenant") if self.tenants.where(active: true).count > 1
  end

  def self.ending_soon?
    lease_end.between?(Date.today, 2.months.since)
  end

end