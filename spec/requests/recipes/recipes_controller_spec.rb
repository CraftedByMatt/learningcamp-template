# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecipesController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_attributes) { { ingredients: "chicken, rice, broccoli" } }
  let(:invalid_attributes) { { ingredients: "" } }

  before do
    sign_in user
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Recipe' do
        expect {
          post :create, params: { recipe: valid_attributes }
        }.to change(Recipe, :count).by(1)
      end

      it 'redirects to the created recipe' do
        post :create, params: { recipe: valid_attributes }
        expect(response).to redirect_to(recipe_path(assigns(:recipe)))
      end
    end

    context 'with invalid params' do
      it 'renders the new template' do
        post :create, params: { recipe: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end
end
