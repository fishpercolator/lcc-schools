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
end
