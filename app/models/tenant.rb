class Tenant < ActiveRecord::Base
  belongs_to :apartment
  has_many :rents
  has_many :notes
  validates :name, presence: true
  validates :email, presence: true
  validates :phone_number, presence: true
  validates :active, presence: true

end