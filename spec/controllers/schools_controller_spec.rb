require 'rails_helper'

RSpec.describe SchoolsController, type: :controller do
  describe '#results' do
    context 'bad or no postcode' do
      before do
        get :results, address: { postcode: 'BAD', name_or_number: '10' }
      end

      it 'assigns the invalid address' do
        expect(assigns[:address]).not_to be_valid
      end

      it 'does not assign anything else' do
        expect(assigns[:home]).to be_nil
        expect(assigns[:schools]).to be_nil
      end

      it 'shows the /apply form again' do
        expect(response).to render_template('apply')
      end
    end
  end
end
