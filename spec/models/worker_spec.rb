require 'rails_helper'

RSpec.describe Worker, type: :model do
  context 'associations' do
    it { is_expected.to have_many(:vacations) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:email) }
  end
end
