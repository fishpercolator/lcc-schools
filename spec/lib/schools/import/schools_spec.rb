require 'rails_helper'
require 'schools/import/schools'

describe Schools::Import::Schools do
  context 'no file' do
    it 'fails' do
      expect { Schools::Import::Schools.new('not there.csv').run! }.to raise_error(
                                                                         Errno::ENOENT
                                                                       )
    end
  end

  context 'everything is fine, and everyone is happy' do
    let(:filename) { 'spec/fixtures/import/schools.csv' }

    before do
      Schools::Import::Schools.new(filename).run!
    end

    it 'imported two schools' do
      expect(School.all.count).to eq(4)
    end

    context 'Secondary school' do
      subject(:school) { School.find_by(code: '5400') }

      example { expect(school.name).to eql('Abbey Grange Church of England Academy') }
      example { expect(school.phase).to eql('Secondary') }
      example { expect(school.type).to eql('Voluntary Aided') }
      example { expect(school.address).to include('Butcher Hill') }
      example { expect(school.available_places).to eql(240) }
      example { expect(school.not_all_nearest).to eql(false) }
      example { expect(school.centroid).not_to be_nil }
    end

    describe 'Not all nearest allocated' do
      subject(:school) { School.find_by(code: '2436') }

      example { expect(school.name).to eql('Alwoodley Primary School') }
      example { expect(school.phase).to eql('Primary') }
      example { expect(school.type).to eql('Community') }
      example { expect(school.address).to include('Cranmer Rise LS17 5HX') }
      example { expect(school.available_places).to eql(60) }
      example { expect(school.not_all_nearest).to eql(true) }
      example { expect(school.centroid).not_to be_nil }
    end
  end
end
