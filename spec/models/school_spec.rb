require 'rails_helper'

describe School do
  describe '#own_admission_policy?' do
    context 'school has LCC admission policy' do
      let(:school) { School.new(name: 'Some school') }
      specify { expect(school).not_to be_own_admission_policy }
    end
    context 'school has LCC admission policy' do
      let(:school) { School.new(name: 'Some school (voluntary aided)') }
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
      it('has priority stats') { school.priority_stats?.should == true }
      it('sums to 3')          { school.sum_of_priorities.should == 3 }
    end
    context 'no stats' do
      let(:school) { School.new }
      it('has no stats') { school.priority_stats?.should == false }
      it('sums to nil')  { school.sum_of_priorities.should be_nil }
    end
  end
end
