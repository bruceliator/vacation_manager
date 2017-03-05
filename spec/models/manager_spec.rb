require 'rails_helper'

RSpec.describe Manager, type: :model do
  context 'associations' do
    it { is_expected.to have_many(:vacations) }
  end
end
