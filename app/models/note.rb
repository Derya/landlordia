class Note < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :apartment
  validates :content, presence: true
  validates :note_type, presence: true
  validates_associated :tenant
  validates_associated :apartment

end