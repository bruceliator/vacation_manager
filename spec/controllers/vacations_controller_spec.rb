require 'rails_helper'

RSpec.describe VacationsController, type: :controller do
  let!(:manager) { create(:manager) }

  subject { response }

  describe '#create' do

    let(:params) { { vacation: attributes_for(:vacation), manager_id: manager.id } }

    context 'when authenticated manager' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[:manager]
        sign_in manager
        post :create, params
      end

      it { is_expected.to have_http_status(302) }
      it { expect(response).not_to redirect_to(new_manager_session_path) }
    end

    context 'when not authenticated manager' do
      before { post :create, params }

      it { expect(response).to redirect_to(new_manager_session_path) }
    end
  end
end
