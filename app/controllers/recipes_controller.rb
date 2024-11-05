# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :authenticate_user!

  def index
    @recipes = Recipe.all
  end

  def new
    @recipe = Recipe.new
  end

  def create
    message = params[:recipe][:ingredients]
    user_id = current_user.id

    begin
      RecipeGeneratorService.new(message, user_id).call
      redirect_to recipes_path, notice: 'Recipe created successfully'
    rescue RecipeGeneratorServiceError => e
      flash[:alert] = e.message
      render :new, status: :unprocessable_entity
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :description, :ingredients)
  end
end
