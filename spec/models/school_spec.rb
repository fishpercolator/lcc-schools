require 'rails_helper'

describe School do
  describe '#own_admission_policy?' do
    context 'school has LCC admission policy' do
      let(:school) { School.new(name: 'Some school') }
      specify { school.should_not be_own_admission_policy }
    end
    context 'school has LCC admission policy' do
      let(:school) { School.new(name: 'Some school (voluntary aided)') }
      specify { school.should be_own_admission_policy }
    end
  end
end
