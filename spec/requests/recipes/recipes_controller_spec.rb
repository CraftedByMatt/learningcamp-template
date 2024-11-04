# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  let(:user) { create(:user) }
  let(:valid_attributes) { { name: 'Test Recipe', description: 'Test Description', ingredients: 'Test Ingredients' } }
  let(:invalid_attributes) { { name: '', description: '', ingredients: '' } }

  before { sign_in user }

  describe 'POST /recipes' do
    context 'with valid attributes' do
      it 'creates a new recipe' do
        expect {
          post recipes_path, params: { recipe: valid_attributes }
        }.to change(Recipe, :count).by(1)
      end

      it 'redirects to the created recipe' do
        post recipes_path, params: { recipe: valid_attributes }
        expect(response).to redirect_to(recipe_path(Recipe.last))
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new recipe' do
        expect {
          post recipes_path, params: { recipe: invalid_attributes }
        }.not_to change(Recipe, :count)
      end

      it 're-renders the new template' do
        post recipes_path, params: { recipe: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end
end
