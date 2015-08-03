require 'rails_helper'

describe SchoolsHelper do
  describe '#priority_height_percent' do
    context 'school has no priorities' do
      let(:school) { create(:school, :availability) }

      it 'has all percentages at 0' do
        School.priorities.each do |attr|
          expect(helper.priority_height_percent(school, attr)).to eql('0%')
        end
      end
    end

    context 'school has some priorities' do
      let(:school) { create(:school, :with_priority_data) }

      example { expect(helper.priority_height_percent(school, :priority1a)).to eql('7%') }
      example { expect(helper.priority_height_percent(school, :priority1b)).to eql('1%') }
      example { expect(helper.priority_height_percent(school, :priority2)).to eql('100%') }
      example { expect(helper.priority_height_percent(school, :priority3)).to eql('1%') }
      example { expect(helper.priority_height_percent(school, :priority4)).to eql('86%') }
      example { expect(helper.priority_height_percent(school, :priority5)).to eql('21%') }
    end
  end

  describe '#contention_badge' do
    let(:options) { {} }
    subject { helper.contention_badge(school, options) }

    context 'oversubscribed' do
      let(:school) { build :school, :oversubscribed }
      it { should eql '<span class="badge badge-contention-medium ">Oversubscribed</span>'}

      context 'with custom class' do
        let(:options) { { class: 'custom-class' } }
        it { should eql '<span class="badge badge-contention-medium custom-class">Oversubscribed</span>'}
      end
    end

    context 'not_all_nearest' do
      let(:school) { build :school, :not_all_nearest }
      it { should eql '<span class="badge badge-contention-high ">Not all nearest allocated</span>'}
    end

    context 'not_all_nearest' do
      let(:school) { build :school, :not_all_nearest }
      it { should eql '<span class="badge badge-contention-high ">Not all nearest allocated</span>'}
    end

    context 'own admissions policy' do
      let(:school) { build :school, :own_admissions_policy }
      it { should eql '<span class="badge badge-contention-unknown ">Unknown</span>'}
    end
  end

end
