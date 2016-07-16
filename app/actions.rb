
helpers do
  def add_errors_to_session(errors)
    errors.full_messages.each do |error_msg|
      session[:flash] = session[:flash] + error_msg + ", "
    end
  end
end

# Homepage (Root path)
get '/' do
  erb :index
end

get '/landlord' do
  @apartments = Apartment.first(16)
  erb :'landlord/index'
end

get '/landlord/apartment/:id' do
  @apartment = Apartment.find params[:id]
  erb :'landlord/apartment/show'
end

get '/landlord/apartment/edit' do
  erb :'landlord/apartment/edit'
end

get '/landlord/apartment/:id/notes' do
  @apartment = Apartment.find(params[:id])
  @notes = @apartment.notes
  erb :'landlord/apartment/notes'
end

get '/landlord/apartment/:id/tenants' do
  @apartment = Apartment.find(params[:id])
  @tenants = @apartment.tenants
  erb :'landlord/apartment/tenants'
end

get '/landlord/apartment/:id/rents' do
  @apartment = Apartment.find(params[:id])
  @rents = @apartment.rents
  erb :'landlord/apartment/rents'
end

get '/tenant/note/new' do
  erb :'tenant/note'
end

post '/tenant/note' do
  @apartment = Apartment.find_by(apartment_number: params[:apartment_number])
  if @apartment
    @apartment.notes.create(
      content: params[:content],
      note_type: params[:type],
      outstanding: true,
      )
    session[:flash] = "Message for apartment #{@apartment.apartment_number} sent."
    redirect '/tenant/note/new'
  else
    session[:flash] = "Could not find apartment #{params[:apartment_number]}."
    redirect '/tenant/note/new'
  end
end

post '/landlord/apartment/:id1/unassign_car_space/:id2' do
  apartment_to = Apartment.find(params[:id1])
  if apartment_to
    car_space = CarSpace.find(params[:id2])
    if car_space
      car_space.apartment = nil
      car_space.save
      session[:flash] = "Parking spot #{car_space.id} unassigned from apartment #{params[:id1]}"
    else
      session[:flash] = "Parking spot #{car_space.id} not found"
    end

    redirect '/landlord/apartment/' + params[:id1].to_s
  else
    session[:flash] = "couldn't find apartment #{params[:id1]}"

    redirect '/landlord'
  end
end

post '/landlord/apartment/:id/assign_car_space' do
  apartment_to = Apartment.find(params[:id])
  car_space = CarSpace.find(params[:new_car_space])
  if apartment_to
    if car_space
      overwriting = car_space.apartment.apartment_number
      car_space.apartment = apartment_to
      car_space.save

      unless overwriting
        session[:flash] = "Parking spot #{car_space.id} assigned to apartment #{params[:id]}"
      else
        session[:flash] = "Parking spot #{car_space.id} unassigned from apt #{overwriting} and assigned to apartment #{params[:id]}"
      end
    else
      session[:flash] = "Parking spot #{car_space.id} not found"
    end

    redirect '/landlord/apartment/' + params[:id].to_s
  else
    session[:flash] = "couldn't find apartment #{params[:id]}"

    redirect '/landlord'
  end
end

post '/landlord/apartment/:id/new_tenant' do
  apartment_to = Apartment.find(params[:id])
  if apartment_to
    new_ten = Tenant.new(name: params[:tenant_name], email: params[:tenant_email], phone_number: params[:tenant_phone], apartment_id: apartment_to.id)
    new_ten.active = (apartment_to.tenant && params[:lease_start] > Time.now) ? "Upcoming" : "Active"
    apartment_to.lease_start = params[:lease_start]
    apartment_to.lease_end = params[:lease_end]
    if new_ten.validate && apartment_to.validate
      # TODO this feels dangerous
      new_ten.save
      apartment_to.save
      session[:flash] = "Created new tenant #{params[:tenant_name]}."
    else
      session[:flash] = "Errors for creating new tenant #{params[:tenant_name]}: "
      add_errors_to_session(new_ten.errors)
      add_errors_to_session(apartment_to.errors)
      session[:flash] = session[:flash].chomp(", ")
    end

  redirect '/landlord/apartment/' + params[:id].to_s
  else
    session[:flash] = "couldn't find apartment #{params[:id]}"

    redirect '/landlord'
  end

  
end

post '/landlord/apartment/:id/update_rent' do
  apartment_to = Apartment.find(params[:id])
  if apartment_to
    new_rent = params[:new_rent].to_f

    # apartment_to.rent = 

    redirect '/landlord/apartment/' + params[:id].to_s
  else
    session[:flash] = "couldn't find apartment #{params[:id]}"

    redirect '/landlord'
  end

end

post '/landlord/apartment/:id/update_lease' do
  apartment_to = Apartment.find(params[:id])
  if apartment_to

    apartment_to.lease_start = params[:lease_start]
    apartment_to.lease_end = params[:lease_end]
    if apartment_to.save
      session[:flash] = "Lease dates updated"
    else
      session[:flash] = "Errors for creating new tenant #{params[:tenant_name]}: "
      apartment_to.errors.full_messages.each do |error_msg|
        session[:flash] = session[:flash] + error_msg + ", "
      end
      session[:flash] = session[:flash].chomp(", ")
    end

    redirect '/landlord/apartment/' + params[:id].to_s
  else
    session[:flash] = "couldn't find apartment #{params[:id]}"

    redirect '/landlord'
  end

end


post '/landlord/apartment/:id/delete_upcoming_tenant' do

  apartment_to = Apartment.find(params[:id])

  if apartment_to

    ten_del = apartment_to.upcoming_tenant

    if ten_del && ten_del.destroy
      session[:flash] = "deleted #{ten_del.name if ten_del.name}"
    else
      session[:flash] = "couldn't delete upcoming tenant for apartment #{params[:id]}"
    end

    redirect '/landlord/apartment/' + params[:id].to_s
  else
    session[:flash] = "couldn't find apartment #{params[:id]}"

    redirect '/landlord'
  end

end


post '/landlord/notes/:id' do
  @note = Note.find(params[:id])
  @note.outstanding = false
  @note.save
  @apartment = Apartment.find(params[:apartment_id])
  redirect "/landlord/apartment/#{@apartment.id}/notes"
end




