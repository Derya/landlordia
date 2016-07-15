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
# Maybe change this to a PUT?
post '/landlord/apartment/:id' do
  # This should get the params[:id] from the url?
  @carspace = CarSpace.find params[:carspace.id]
  # This is checking if the carspace apartment_id is different to the one you're trying to change it to but it's not empty.

  # If it's different, give a flash to say that it's being overwritten
  unless @carspace.apartment_id.nil?
    session[:flash] = "Carspace #{@carspace.id} has been moved to this apartment"
  else
    # Otherwise just let them know it has been changed (this would be if it's empty of the same as the one you're trying to change it to, which would be stupid but ya know, people can be stupid)
    session[:flash] = "Carspace #{@carspace.id} has been assigned to this apartment"
  end
  @carspace.update(apartment_id: params[:id])
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
  @apartment.notes.create(
    content: params[:content],
    note_type: params[:type],
    outstanding: true,
    )
  redirect '/'
end