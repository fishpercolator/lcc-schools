require 'rails_helper'

RSpec.describe Address, type: :model do
  describe '#geocoding_info' do
    let(:address) { Address.new name_or_number: '79', postcode: 'LS8 1JU' }

    specify { expect(address.geocoding_info).to eql('79, LS8 1JU') }
  end
end
