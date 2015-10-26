require 'rails_helper'

RSpec.describe Address, type: :model do
  describe '#geocoding_info' do
    let(:address) { Address.new name_or_number: '79', postcode: 'LS8 1JU' }

    specify { expect(address.geocoding_info).to eql('79, LS8 1JU') }
  end

  describe '.lookup' do
    subject(:address) { Address.lookup('LS8 1JU', '30') }

    GEOCODER_LATITUDE  = 53.0
    GEOCODER_LONGITUDE = -1.2
    DATABASE_LATITUDE = 50
    DATABASE_LONGITUDE = -1

    before do
      Geocoder.configure(:lookup => :test)

      Geocoder::Lookup::Test.set_default_stub(
        [
          {
            'latitude'  => GEOCODER_LATITUDE,
            'longitude' => GEOCODER_LONGITUDE,
            'address'   => 'Test address'
          }
        ]
      )
    end

    context 'postcode and name/number input are fine' do
      context 'an address has previously been looked up' do
        let!(:pre_existing_address) do
          Address.create postcode: 'LS8 1JU',
                         name_or_number: '30',
                         latitude: DATABASE_LATITUDE,
                         longitude: DATABASE_LONGITUDE
        end

        it 'populates lat/long from the database' do
          expect(address.latitude).to eql(50.0)
          expect(address.longitude).to eql(-1.0)
        end
      end

      context 'no address has previously been looked up' do
        it 'populates lat/long from the geocoder' do
          expect(address.latitude).to eql(GEOCODER_LATITUDE)
          expect(address.longitude).to eql(GEOCODER_LONGITUDE)
        end
      end
    end
  end
end
