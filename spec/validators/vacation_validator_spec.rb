require 'rails_helper'

RSpec.describe VacationValidator do

  subject { Vacation.new(params) }

  let(:vacationable) { create(:manager) }
  let(:params) { { vacationable: vacationable }.merge(additional_params) }
  let(:beginning_of_year) { Date.today.beginning_of_year }

  before { subject.valid? }

  describe 'end_date validation' do
    context 'when end date before start' do
      let(:additional_params) { { start_date: Date.today, end_date: 2.days.ago } }

      it { is_expected.not_to be_valid }
      it 'fails validation on end_date' do
        expect(subject).to have(1).error_on(:end_date)
      end
    end

    context 'when end date after start' do
      let(:additional_params) { { start_date: 1.day.since, end_date: 10.days.since } }

      it { is_expected.to be_valid }
    end
  end

  describe 'future start_date' do
    context 'when start date in past' do
      let(:additional_params) { { start_date: 2.days.ago, end_date: Date.today } }

      it { is_expected.not_to be_valid }
      it 'fails validation on end_date' do
        expect(subject).to have(1).error_on(:start_date)
      end
    end

    context 'when start date in future' do
      let(:additional_params) { { start_date: 2.days.since, end_date: 10.days.since } }

      it { is_expected.to be_valid }
    end
  end

  describe 'vacation length' do
    context 'when too long vacation' do
      let(:additional_params) { { start_date: 1.day.from_now, end_date: 60.days.from_now } }

      it { is_expected.not_to be_valid }
      it 'fails validation on vacation_length_invalid' do
        expect(subject).to have(2).error_on(:base)
      end
    end

    context 'when valid vacation duration' do
      let(:additional_params) { { start_date: 1.day.from_now, end_date: 10.days.from_now } }

      it { is_expected.to be_valid }
    end
  end

  describe 'current year limit' do

    before do
      Timecop.freeze(beginning_of_year)
      create(:vacation, vacationable: vacationable, start_date: 1.day.since, end_date: 30.days.since)
    end

    after { Timecop.return }

    context 'when limit exceeded' do

      let(:additional_params) { { start_date: 150.days.from_now, end_date: 180.days.from_now } }

      it { is_expected.not_to be_valid }
      it 'fails validation on vacations year limit' do
        expect(subject).to have(1).error_on(:base)
      end
    end

    context 'when limit not exceeded' do

      let(:additional_params) { { start_date: 150.days.from_now, end_date: 155.days.from_now } }

      it { is_expected.to be_valid }
    end
  end

  describe 'current year limit' do
    before do
      Timecop.freeze(beginning_of_year)
      3.times do |i|
        vacation_duration = 5
        start_date = ((Vacation::MIN_GAP_BETWEEN_VACATIONS + 1 + vacation_duration) * i + 1).days.from_now # to make gap between vacations more than 60 days
        create(:vacation,
               vacationable: vacationable,
               start_date: start_date,
               end_date: start_date + vacation_duration.days
        )
      end
      subject.valid?
    end

    after { Timecop.return }

    context 'when vacations count exceeded' do
      let(:end_of_year) { Date.today.end_of_year }
      let(:additional_params) { { start_date: end_of_year - 5.days, end_date: end_of_year - 2.days } }

      it { is_expected.not_to be_valid }
      it 'fails on vacations count in year' do
        expect(subject).to have(1).error_on(:base)
      end
      it 'should show message' do
        expect(subject.errors.messages[:base]).to include('too much vacations in this year')
      end
    end
  end

  describe 'gap between vacations' do
    let(:invalid_gap) { 10.days }

    before { Timecop.freeze(beginning_of_year) }
    after { Timecop.return }

    context 'when one vacation before exists' do
      let(:previous_start_date) { beginning_of_year + 1.day }
      let(:previous_end_date) { previous_start_date + 5.days }
      let(:start_date) { previous_end_date + invalid_gap }
      let(:additional_params) { { start_date: start_date, end_date: start_date + 5.days  } }

      before do
        create(:vacation,
               vacationable: vacationable,
               start_date: previous_start_date,
               end_date: previous_end_date
        )
        subject.valid?
      end

      it { is_expected.not_to be_valid }
      it 'fails on previous vacation gap' do
        expect(subject).to have(1).error_on(:base)
      end
      it 'should show message' do
        expect(subject.errors.messages[:base]).to include('previous or next vacation too close')
      end
    end

    context 'when one vacation after exists' do
      let(:next_start_date) { DateTime.now.end_of_year - 10.days }
      let(:next_end_date) { next_start_date + 5.days }
      let(:end_date) { next_start_date - invalid_gap }
      let(:additional_params) { { start_date: end_date - 5.days, end_date: end_date  } }

      before do
        create(:vacation,
               vacationable: vacationable,
               start_date: next_start_date,
               end_date: next_end_date
        )
        subject.valid?
      end

      it { is_expected.not_to be_valid }
      it 'fails on next vacation gap' do
        expect(subject).to have(1).error_on(:base)
      end
      it 'should show message' do
        expect(subject.errors.messages[:base]).to include('previous or next vacation too close')
      end
    end

    context 'when valid vacation gaps' do
      let(:next_start_date) { DateTime.now.end_of_year - 10.days }
      let(:next_end_date) { next_start_date + 5.days }
      let(:end_date) { next_start_date - (Vacation::MIN_GAP_BETWEEN_VACATIONS + 1).days }
      let(:additional_params) { { start_date: end_date - 5.days, end_date: end_date  } }

      before do
        create(:vacation,
               vacationable: vacationable,
               start_date: next_start_date,
               end_date: next_end_date
        )
        subject.valid?
      end

      it { is_expected.to be_valid }
    end
  end
end

