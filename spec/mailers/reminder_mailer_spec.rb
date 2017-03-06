require 'rails_helper'

RSpec.describe ReminderMailer, type: :mailer do
  describe 'reminder_email' do
    context 'headers' do
      let(:manager_emails) { %w(john_doe@gmail.com foo@gmail.com) }
      let(:worker_emails) { %w(bar@gmail.com foobar@gmail.com) }
      let(:mail) { described_class.reminder_email }

      before do
        allow(Manager).to receive(:pluck).and_return(manager_emails)
        allow(Worker).to receive(:pluck).and_return(worker_emails)
      end

      it 'sends to the right email' do
        expect(mail.to).to eq manager_emails + worker_emails
      end

      it 'renders the from email' do
        expect(mail.from).to eq ['vacation@example.com']
      end
    end
  end
end
