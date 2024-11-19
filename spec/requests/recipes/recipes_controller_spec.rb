# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecipesController, type: :controller do
  let(:user) { create(:user) }
  let!(:recipe) { create(:recipe, user: user) }

  before do
    sign_in user
  end

  describe 'GET #show' do
    context 'when the recipe exists' do
      it 'assigns the requested recipe to @recipe' do
        get :show, params: { id: recipe.id }
        expect(assigns(:recipe)).to eq(recipe)
      end

      it 'renders the show template' do
        get :show, params: { id: recipe.id }
        expect(response).to render_template(:show)
      end
    end

    context 'when the recipe does not exist' do
      it 'raises an ActiveRecord::RecordNotFound error' do
        expect {
          get :show, params: { id: 'nonexistent_id' }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when the recipe is successfully destroyed' do
      it 'redirects to the recipes index with a success notice' do
        expect {
          delete :destroy, params: { id: recipe.id }
        }.to change(Recipe, :count).by(-1)
        expect(response).to redirect_to(recipes_path)
        expect(flash[:notice]).to eq(I18n.t('views.recipes.destroy_success'))
      end
    end
  end
end
