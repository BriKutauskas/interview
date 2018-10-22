require 'sinatra/base'
Dir['./lib/*.rb'].each {|f| require f}

class Main < Sinatra::Base


  COORDS = [
      [61.582195, -149.443512],
      [44.775211, -68.774184],
      [25.891297, -97.393349],
      [45.787839, -108.502110],
      [35.109937, -89.959983],
  ]

  white_house = Address.new
  DC_COORDINATES = white_house.location('1600 Pennsylvania Avenue NW, Washington, DC 20500, USA')

  def format_addresses
    @addresses =  COORDS.map {|coord|
      new_address = Address.new
      street = new_address.postal_address(coord[0], coord[1])
      miles = new_address.miles_to(DC_COORDINATES)
      {"miles_to_dc" => miles, "street_address"=> street}
    }
  end

  def distance_to_dc
    @sorted_addresses = @addresses.sort_by {|address| address['miles_to_dc']}
  end

  get '/' do
    format_addresses
    distance_to_dc
    erb :index, locals: {addresses: @sorted_addresses}
  end
end
