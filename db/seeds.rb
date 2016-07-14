# empty our database
Apartment.delete_all
CarSpace.delete_all
Note.delete_all
Rent.delete_all
Tenant.delete_all

require 'faker'

# constants
NUM_APTS = 16
DATE_START = 2.years.ago
END_DATE = Time.now
NUM_PARKING_LOTS = 10

# helper to get a random duration (not a date)
def get_random_period_of_time
  ((0..26).to_a).sample.days + ((0..2).to_a).sample.months
end

def get_random_rent
  #TODO: randomize this
  9_999.99
end

NUM_APTS.times do
  apt = Apartment.new
  # make a new apartment
  apt.apartment_number = Faker::Number.number(3)

  apt_monthly_rent = get_random_rent

  # start simulating our history
  time = DATE_START

  # loop over time
  loop do
    # move out old tenant (unless this is first iteration in loop)
    if ten
      ten.active = false
      ten.save
    end

    # vacancy period of time
    time += get_random_period_of_time

    # we are done loop if time has passed end date
    break if time > END_DATE

    # make a new tenant
    ten = Tenant.new
    # give them some info
    ten.name = Faker::Name.name_with_middle
    ten.phone_number = Faker::PhoneNumber.phone_number
    ten.email = Faker::Internet.email
    # make them active for now
    ten.active = true
    # associate with apartment
    apt.tenants << ten

    # simulate this lease happening

    # lease start is now
    apt.lease_start = time

    # get a random duration for how long this lease is for
    lease_duration = get_random_period_of_time * 7

    # lease end is after the duration of the lease
    apt.lease_end = time + lease_duration

    # repeating above logic into new local variables for readability
    rental_start = time
    # we dont want to make rent payment entries in the future, so we only count 
    # rental period before the future
    rental_end = (rental_end > END_DATE) ? END_DATE : time + lease_duration

    # we are now going to move forward month by month
    while time < rental_end.beginning_of_month do
      # move time to start of next month
      time = time.beginning_of_month.next_month

      # make rental payment
      rent = Rent.new
      # add misc data
      rent.amount = apt_monthly_rent
      rent.month = time
      #TODO: randomize this:
      rent.pay_status = "paid"
      apt.rents << rent
      ten.rents << rent
      rent.save

      # make 1d4-1 random notes

      [0,1,2,3].times do
        # make a random note from this month
        note = Note.new
        #add misc data
        note.content = Faker::Lorem.sentence(10)
        note.type = ["service request","notification"].sample
        note.outstanding = [true,false].sample
        apt.notes << note
        ten.notes << note
      end

      # are these even necessary?
      apt.save
      ten.save

    end

    # save the tenant
    ten.save

  end

  # save apartment
  apt.save

end

# assign the parking spots
NUM_PARKING_LOTS.times do
  lot = ParkingLot.new
  # just assign it randomly HAHAHAHA
  Apartment.all.sample.parking_lots << lot
  lot.save
end



