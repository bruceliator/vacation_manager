require 'rails_helper'

RSpec.describe Vacation, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:vacationable) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:end_date) }
  end
end
