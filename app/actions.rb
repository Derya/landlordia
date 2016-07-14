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
post 'landlord/apartment/:id' do
  # This should get the params[:id] from the url?
  @carspace = CarSpace.find params[:carspace.id]
  # This is checking if the carspace apartment_id is different to the one you're trying to change it to but it's not empty.
  # If it's different, give a flash to say that it's being overwritten
  if @carspace.apartment_id != (params[:id] && nil)
    session[:flash] = "Carspace has been overwritten"
  else
    # Otherwise just let them know it has been changed (this would be if it's empty of the same as the one you're trying to change it to, which would be stupid but ya know, people can be stupid)
    session[:flash] = "Carspace has been changed"
  end
  @carspace.update(apartment_id: params[:id])
end

get 'landlord/apartment/:id/notes' do
  @notes = Apartment.where(id: params[:id]).notes
  erb :'landlord/apartment/notes'
end

get 'landlord/apartment/:id/tenants' do
  @tenants = Apartment.where(id: params[:id]).tenants
  erb :'landlord/apartment/tenants'
end

get 'landlord/apartment/:id/rents' do
  @rents = Apartment.where(id: params[:id]).rents
  erb :'landlord/apartment/rent'
end

get 'tenant/note/new' do
  erb :'tenant/note/new'
end