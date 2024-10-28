# == Schema Information
#
# Table name: preferences
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  description :text             not null
#  restriction :boolean          default(FALSE), not null
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_preferences_on_user_id  (user_id)
#
require 'rails_helper'

describe Preference  do
  describe 'validations' do
    subject { build(:preference) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
  end

  context 'when was created with regular login' do
    let!(:user) { create(:user) }
    let!(:preference) { create(:preference, user:) }
    let(:name) { preference.name }
    let(:description) { preference.description }
    let(:restriction) { preference.restriction }

    it 'returns the correct attributes' do
      expect(name).to eq(preference.name)
      expect(description).to eq(preference.description)
      expect(restriction).to eq(preference.restriction)
    end

    it { is_expected.to belong_to(:user) }
  end
end
