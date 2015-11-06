require 'rails_helper'

describe School do
  describe '#own_admission_policy?' do
    context 'school has LCC admission policy' do
      let(:school) { School.new(name: 'Some school', type: 'Community') }
      specify { expect(school).not_to be_own_admission_policy }
    end
    context 'school has LCC admission policy' do
      let(:school) { School.new(name: 'Some school', type: 'Voluntary Aided') }
      specify { expect(school).to be_own_admission_policy }
    end
    context 'school has LCC admission policy' do
      let(:school) { School.new(name: 'Some school', type: 'Foundation') }
      specify { expect(school).to be_own_admission_policy }
    end
    context 'school has LCC admission policy' do
      let(:school) { School.new(name: 'Some school', type: 'Academy') }
      specify { expect(school).to be_own_admission_policy }
    end
    context 'school has LCC admission policy' do
      let(:school) { School.new(name: 'Khalsa Science Academy Free School', type: 'Academy') }
      specify { expect(school).to be_own_admission_policy }
    end
  end

  describe '#contended?' do
    context 'no contention' do
      let(:school) { School.new(name: 'Some school', available_places: 99, nearest: nil)}
      specify { expect(school).not_to be_contended }
    end
    context 'contention' do
      let(:school) { School.new(name: 'Some school', available_places: 99, nearest: 0.5)}
      specify { expect(school).to be_contended }
    end
  end

  describe '#priority_stats?, #sum_of_priorities' do
    context 'some stats' do
      let(:school) { School.new(priority1a: 1, priority5: 2) }
      it('has priority stats') { expect(school.priority_stats?).to eql(true) }
      it('sums to 3')          { expect(school.sum_of_priorities).to eql(3) }
    end
    context 'no stats' do
      let(:school) { School.new }
      it('has no stats') { expect(school.priority_stats?).to eql(false) }
      it('sums to nil')  { expect(school.sum_of_priorities).to be_nil }
    end
  end
end
