# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Edit preference' do
  let!(:user) { create(:user) }
  let!(:preference) { create(:preference, user:) }

  before do
    sign_in user
    visit preferences_path
  end

  describe '#update' do
    context 'with valid attributes' do
      it 'updates the requested preference' do
        edit_first_preference('New preference')
        expect(page).to have_content('Preference successfully updated.')
        expect(find('input[name="preference[name]"]').value).to eq('New preference')
        expect(find('input[name="preference[description]"]').value).to eq('Test description')
        expect(preference.reload.restriction).to be(true)
      end
    end

    context 'with invalid attributes' do
      it 'renders the edit template with error messages' do
        edit_first_preference('')
        expect(page).to have_text("Name can't be blank", wait: 5)
      end
    end
  end

  def edit_first_preference(name)
    within all('tbody tr').first do
      click_on 'Edit'
    end
    fill_in 'Name', with: name
    fill_in 'Description', with: 'Test description'
    check 'Restriction'
    click_on 'Update Preference'
  end
end
