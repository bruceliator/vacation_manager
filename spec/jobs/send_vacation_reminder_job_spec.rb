require 'rails_helper'

RSpec.describe SendVacationReminderJob, type: :job do
  describe '#perform' do
    it 'calls on the ReminderMailer' do
      allow(ReminderMailer).to receive_message_chain(:reminder_email, :deliver_later)

      described_class.new.perform

      expect(ReminderMailer).to have_received(:reminder_email)
    end
  end

  describe '.perform_later' do
    it 'adds the job to the queue :vacation_info' do
      allow(ReminderMailer).to receive_message_chain(:reminder_email, :deliver_later)

      described_class.perform_later(1)

      expect(enqueued_jobs.last[:job]).to eq described_class
    end
  end
end
