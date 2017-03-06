require 'rails_helper'

RSpec.describe SendVacationInformationJob, type: :job do
  describe '#perform' do
    it 'calls on the VacationMailer' do
      vacation = double('vacation', id: 1)
      allow(VacationMailer).to receive_message_chain(:vacation_email, :deliver_later)

      described_class.new.perform(vacation)

      expect(VacationMailer).to have_received(:vacation_email)
    end
  end

  describe '.perform_later' do
    it 'adds the job to the queue :vacation_info' do
      allow(VacationMailer).to receive_message_chain(:vacation_email, :deliver_later)

      described_class.perform_later(1)

      expect(enqueued_jobs.last[:job]).to eq described_class
    end
  end
end
