# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :authenticate_user!

  def index
    @recipes = Recipe.all
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)

    if @recipe.save!
      redirect_to recipe_path(@recipe), notice: t('views.recipes.create_success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :description, :ingredients)
  end
end
