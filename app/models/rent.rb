class Rent < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :apartment
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :month, presence: true
  validates :pay_status, presence: true
  validates_associated :tenants
  validates_associated :apartments

end