require_relative 'geocoding'


class Address
  attr_reader :lat, :lng, :full_address

  def postal_address(lat, lng)
    @lat = lat
    @lng = lng
    @full_address = Geocoder.search([@lat, @lng]) rescue []
    puts @full_address
  end

  def reverse_geocoded?
    !@full_address.nil?
  end

  def location(full_address)
      @full_address = full_address
      result = Geocoder.search(full_address).first.data rescue []
      unless result.empty?
        @lat = result['latt']
        @lng = result['longt']
      end
  end

  def geocoded?
    !@lat.nil? && !@lng.nil?
  end

end


