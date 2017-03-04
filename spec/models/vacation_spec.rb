require 'rails_helper'

RSpec.describe Vacation, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:vacationable) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:end_date) }
  end

  describe 'scopes' do
    context '.in_year' do
      subject { Vacation.in_year(today_date) }

      let(:today_date) { Date.today }
      let(:next_year_date) { today_date.next_year }
      let(:next_year_vacation) { create(:vacation, start_date: next_year_date) }
      let(:this_year_vacation) { create(:vacation, start_date: today_date + 1.day) }

      it { is_expected.to include(this_year_vacation) }
      it { is_expected.not_to include(next_year_vacation) }
    end

    context '.ending_before_some_date' do
      subject { Vacation.ending_before_some_date(date) }

      let(:date) { 10.days.from_now }
      let(:before_date_vacation) { create(:vacation, start_date: date - 5.days) }
      let(:after_date_vacation) { create(:vacation, start_date: date + 5.days) }

      it { is_expected.to include(before_date_vacation) }
      it { is_expected.not_to include(after_date_vacation) }
    end

    context '.starting_after_some_date' do
      subject { Vacation.starting_after_some_date(date) }

      let(:date) { 10.days.from_now }
      let(:start_before_date) { create(:vacation, start_date: date - 1.day) }
      let(:start_after_date) { create(:vacation, start_date: date + 1.day) }

      it { is_expected.to include(start_after_date) }
      it { is_expected.not_to include(start_before_date) }
      end

    context '.in_range_by_type' do
      subject { Vacation.in_range_by_type(range_start, range_end, type) }

      before { create_list(:manager, 25) }

      let(:type) { 'Manager' }
      let(:range_start) { 10.days.from_now }
      let(:range_end) { 20.days.from_now }
      let(:in_range) { create(:manager_vacation, start_date: range_start + 5.days) }
      let(:also_in_range) { create(:manager_vacation, start_date: range_start + 1.day) }
      let(:before_range) { create(:manager_vacation, start_date: range_start - 5.days) }
      let(:after_range) { create(:manager_vacation, start_date: range_end + 1.day) }

      it { is_expected.to include(also_in_range) }
      it { is_expected.to include(in_range) }
      it { is_expected.not_to include(before_range) }
      it { is_expected.not_to include(after_range) }
    end
  end
end
