class Note < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :apartment
  validates :content, presence: true
  validates :type, presence: true
  validates :outstanding, presence: true
  validates_associated :tenants
  validates_associated :apartments

end