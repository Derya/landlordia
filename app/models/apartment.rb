class Apartment < ActiveRecord::Base
  has_many :tenants
  has_many :rents
  has_many :notes
  has_many :car_spaces

end