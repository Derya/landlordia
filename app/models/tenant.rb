class Tenant < ActiveRecord::Base
  belongs_to :apartment
  has_many :rents
  has_many :notes

end