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
NUM_PARKING_LOTS = 20

# helper to get a random duration (not a date)
def get_random_period_of_time
  ((0..26).to_a).sample.days + ((0..2).to_a).sample.months
end

def get_random_rent
  #TODO: randomize this
  9_999.99
end

NUM_APTS.times do
  @apt = Apartment.new
  # make a new apartment
  @apt.apartment_number = Faker::Number.number(3)

  @apt_monthly_rent = get_random_rent

  # start simulating our history
  time = DATE_START

  # this tenant doesn't get used, hopefully
  @tenant = Tenant.new(name: "sdfgvfghnbvcfghgvfghnb")

  # vacancy period of time
  time += get_random_period_of_time

  # loop over time
  while time < END_DATE do

    # move out old tenant
    @tenant.active = false
    @tenant.save unless @tenant.name == "sdfgvfghnbvcfghgvfghnb"

    # make a new tenant
    @tenant = Tenant.new
    # give them some info
    @tenant.name = Faker::Name.name_with_middle
    @tenant.phone_number = Faker::PhoneNumber.phone_number
    @tenant.email = Faker::Internet.email
    # make them active for now
    @tenant.active = true
    # associate with apartment
    @tenant.apartment = @apt

    # simulate this lease happening

    # lease start is now
    @apt.lease_start = time

    # get a random duration for how long this lease is for
    lease_duration = get_random_period_of_time * 7

    # lease end is after the duration of the lease
    @apt.lease_end = time + lease_duration

    # repeating above logic into new local variables for readability
    rental_start = time
    # we dont want to make rent payment entries in the future, so we only count 
    # rental period before the future
    rental_end = time + lease_duration
    rental_end = END_DATE if rental_end > END_DATE

    # we are now going to move forward month by month
    while time < rental_end.beginning_of_month do
    # binding.pry
      # move time to start of next month
      time = time.beginning_of_month.next_month

      # make rental payment
      rent = Rent.new
      # add misc data
      rent.amount = @apt_monthly_rent
      rent.month = time
      #TODO: randomize this:
      rent.pay_status = "paid"
      rent.apartment = @apt
      rent.tenant = @tenant
      rent.save

      # make 1d4-1 random notes

      [0,1,2,3].sample.times do
        # make a random note from this month
        note = Note.new
        #add misc data
        note.content = Faker::Lorem.sentence(10)
        note.note_type = ["service request","notification"].sample
        note.outstanding = [true,false,false,false,false].sample
        note.apartment_id = @apt.id
        note.tenant_id = @tenant.id
        note.save
      end

      # are these even necessary?
      #@apt.save
      #@tenant.save

    end

    # save the tenant
    @tenant.save



    # vacancy period of time
    time += get_random_period_of_time

  end

  # save apartment
  @apt.save

end


NUM_PARKING_LOTS.times do
  lot = CarSpace.new
  lot.apartment = Apartment.all.sample
  lot.save
end



