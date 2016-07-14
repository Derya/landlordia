class Rent < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :apartment

end