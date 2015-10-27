require 'rails_helper'

RSpec.describe Address, type: :model do
  describe '#geocoding_info' do
    let(:address) { Address.new name_or_number: '79', postcode: 'LS8 1JU' }

    specify { expect(address.geocoding_info).to eql('79, LS8 1JU') }
  end

  describe '.lookup' do
    let(:postcode) { 'LS8 1JU' }
    let(:number)   { '30' }

    subject(:address) { Address.lookup(postcode, number) }

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

    context 'The postcode needs normalising' do
      let(:postcode) { 'LS8   1JU   ' }

      it 'normalises the postcode' do
        expect(address.postcode).to eql('LS8 1JU')
      end
    end

    context 'postcode is bad' do
      context 'not a postcode' do
        let(:postcode) { 'WRONG' }

        it { should_not be_valid }

        it 'should not have any positional values' do
          expect(address.latitude).to be_nil
          expect(address.longitude).to be_nil
        end

        it 'should have an error on the postcode field' do
          expect(address.errors[:postcode].first).to eql('not recognised as a UK postcode')
        end
      end

      context 'blank postcode' do
        let(:postcode) { '' }

        it { should_not be_valid }

        it 'should not have any positional values' do
          expect(address.latitude).to be_nil
          expect(address.longitude).to be_nil
        end

        it 'should have an error on the postcode field' do
          expect(address.errors[:postcode].first).to eql("can't be blank")
        end
      end

      context 'not a full postcode' do
        let(:postcode) { 'LS1' }

        it { should_not be_valid }

        it 'should have an error on the postcode field' do
          expect(address.errors[:postcode].first).to eql('must be a full UK postcode')
        end
      end
    end
  end
end
