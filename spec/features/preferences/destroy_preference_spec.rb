# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Destroy preference' do
  let!(:user) { create(:user) }
  let!(:preference) { create(:preference, user:) }

  before do
    sign_in user
    visit preferences_path
  end

  describe '#destroy' do
    it 'destroys the requested preference' do
      destroy_first_preference
      expect(page).to have_content('Preference successfully removed.')
      expect(page).to have_no_content(preference.name)
    end
  end

  def destroy_first_preference
    within all('tbody tr').first do
      click_on 'Remove'
    end
  end
end
