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

  describe '#school_filter_link' do
    let(:current_scopes) {{}}

    before { allow(helper).to receive(:current_scopes).and_return(current_scopes) }

    subject(:markup) { helper.school_filter_link(text, name, value, options) }

    it 'is not liberal in what it expects' do
      expect { helper.school_filter_link 'Text', 'string_name', '1' }.to raise_error(
                                                                         ArgumentError,
                                                                         /name must be a symbol/
                                                                       )
    end

    context 'by_admission_policy' do
      let(:text)  { 'Own' }
      let(:name)  { :by_admission_policy }
      let(:value) { 'own_admissions_policy' }
      let(:options) { { glyphs: %w(own-admissions-policy) } }

      context 'is not selected' do
        let(:current_scopes) { {something: 'else'} }

        it { should be_an(ActiveSupport::SafeBuffer) }
        it { should include ('Own') }
        it { should include ('<a class="btn') }
        it { should_not include ('<span class="btn') }
        it { should include('<span class="image-glyph own-admissions-policy"')}
        it { should include('something=else')}
        it { should include('by_admission_policy=own_admissions_policy')}
      end

      context 'is already selected' do
        let(:current_scopes) { {something: 'else', by_admission_policy: 'own_admissions_policy'} }

        it { should be_an(ActiveSupport::SafeBuffer) }
        it { should_not include ('<a class="btn') }
        it { should include ('<span class="btn') }
        it { should include ('active') }
        it { should include('<span class="image-glyph own-admissions-policy"')}
      end
    end

    context '"All" links' do
      let(:current_scopes) { { phase: 'Primary', something: 'else' } }

      let(:text)    { 'All' }
      let(:name)    { :phase }
      let(:value)   { :all }
      let(:options) { { glyphs: %w(some-glyph) } }

      it { should_not include('phase')}
      it { should_not include('active')}
      it { should     include('something=else')}
      it { should     include('<span class="image-glyph some-glyph')}

      context 'is selected' do
        let(:current_scopes) { {} }

        it { should match(/class=.*active/) }
      end
    end
  end

end
