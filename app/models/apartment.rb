class Apartment < ActiveRecord::Base
  has_many :tenants
  has_many :rents
  has_many :notes
  has_many :car_spaces
  validates :apartment_number, presence: true
  validate :lease_times
  validate :at_most_one_tenant_active

  MONTHS_NOTICE = 2

  def tenant_name
    if self.tenant
      self.tenant.name
    else
      "unoccupied"
    end
  end
  def tenant_email_mailto
    if self.tenant
      "mailto:#{self.tenant.email}"
    else
      "#"
    end
  end

  def tenant
    self.tenants.find_by(active: "Active")
  end

  def upcoming_tenant
    self.tenants.find_by(active: "Coming up")
  end

  def lease_ending?
    lease_end.between?(Date.today, MONTHS_NOTICE.months.since)
  end

  def self.lease_ending
    Apartment.where(lease_end: (Date.today)..(MONTHS_NOTICE.months.since))
  end

  def outstanding?
    notes.find_by(outstanding: true)
  end

  def overdue?
    if tenant
      tenant.rents.find_by(pay_status: 'Not paid')
    else
      false
    end
  end

  private

  def lease_times
    errors.add(:base,"lease start must be before lease end") if lease_start && lease_end && lease_start > lease_end
  end

  def at_most_one_tenant_active
    errors.add(:base,"can have at most 1 active tenant") if self.tenants.where(active: "Active").count > 1
  end

  

end