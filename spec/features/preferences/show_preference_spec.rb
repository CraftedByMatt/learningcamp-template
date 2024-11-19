# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Show preference', :js do
  let(:user) { create(:user) }
  let!(:preference) { create(:preference, user:) }

  before do
    sign_in user
    visit preferences_path
    show_first_preference
  end

  describe '#show' do
    context 'when clicking on some preference' do
      it 'show the data the requested preference' do
        within '#panel' do
          expect(page).to have_content('Name')
          expect(page).to have_content('Description')
          expect(page).to have_content('Restriction')
        end
      end
    end
  end

  def show_first_preference
    within all('tbody tr').first do
      click_on 'Show'
    end
  end
end
