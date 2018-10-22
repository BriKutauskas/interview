RSpec.describe Address do
  let(:full_address) { '1600 Pennsylvania Avenue NW, Washington, DC 20500, USA' }
  let(:lat) { 40.181306 }
  let(:lng) { -80.265949 }

  Geocoder.configure(lookup: :test)

  before(:each) do
    Geocoder::Lookup::Test.set_default_stub(
        [
            {
                'coordinates'  => [40.181306, -80.265949],
                'latt'         => 40.181306,
                'longt'        => -80.265949,
                'address'      => 'Washington, PA, USA',
                'state'        => 'Pennsylvania',
                'state_code'   => 'PA',
                'country'      => 'United States',
                'country_code' => 'US'
            }
        ]
    )
  end

  after(:each) do
    Geocoder::Lookup::Test.reset
  end

  subject(:address) { described_class.new }

  describe 'geocoding' do
    let(:payload) {{  'longt' => lng, 'latt' => lat }}
    let(:result) { [ double(data: payload) ] }

    it 'geocodes with Geocoder API' do
      expect(Geocoder).to receive(:search).with(full_address).and_return result
      address.location(full_address)
    end

    it 'is geocoded' do
      address.location(full_address)
      expect(address).to be_geocoded
    end
  end

  describe 'reverse geocoding' do
    let :payload do
      {   
        'usa'=> {
          'uscity' => 'WASHINGTON',
          'usstnumber' => '1',
          'state' => 'PA',
          'zip' => '20500',
          'usstaddress' => 'Pennsylvania AVE'
        }
      }
    end
    
    let(:result) { [ double(data: payload) ] }

    it 'reverse geocodes with Geocoder API' do
      expect(Geocoder).to receive(:address).with([lat, lng]).and_return result
      address.postal_address(lat, lng)
    end

    it 'is reverse geocoded' do
      address.postal_address(lat, lng)
      expect(address).to be_reverse_geocoded
    end
  end

  describe 'distance finding' do
    let(:detroit) { FactoryGirl.build :address, :as_detroit }
    let(:kansas_city) { FactoryGirl.build :address, :as_kansas_city }


    it 'calculates distance with the Geocoder API' do
      expect(Geocoder::Calculations).to receive(:distance_between).with detroit.coordinates, kansas_city.coordinates
      detroit.miles_to(kansas_city.coordinates)
    end

    it 'returns the distance between two addresses' do
      expect(detroit.miles_to(kansas_city.coordinates)).to be > 0
    end
  end
end
