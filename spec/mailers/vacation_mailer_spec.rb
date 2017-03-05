require 'rails_helper'

describe VacationMailer  do
  describe 'vacation_email' do
    context 'headers' do
      let!(:manager) { create(:manager) }
      let(:vacation) { build(:vacation) }
      let(:mail) { described_class.vacation_email(vacation) }

      it 'sends to the right email' do
        expect(mail.to).to include manager.email
      end

      it 'renders the from email' do
        expect(mail.from).to eq ['vacation@example.com']
      end

      it "includes the correct information" do
        expect(mail.body.encoded).to include vacation.vacationable.email
      end
    end
  end
end