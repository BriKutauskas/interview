require_relative 'geocoding'


class Address
  attr_accessor :lat, :lng, :full_address, :coordinates

  def postal_address(lat, lng)
    @lat = lat
    @lng = lng
    @coordinates = [@lat, @lng]
    @full_address = Geocoder.address(@coordinates) rescue ""
  end

  def reverse_geocoded?
    !@full_address.nil?
  end

  def location(full_address)
      @full_address = full_address
      result = search(full_address)
      unless result.empty?
        @lat = result['latt'].to_i
        @lng = result['longt'].to_i
        @coordinates = [@lat, @lng]
      end
  end

  def geocoded?
    !@lat.nil? && !@lng.nil?
  end

  def search(address)
    Geocoder.search(address).first.data rescue []
  end

  def miles_to(end_point)
   if self.geocoded?
    Geocoder::Calculations.distance_between(@coordinates, end_point)
   elsee
     puts "Address not geocoded"
   end
  end

end


