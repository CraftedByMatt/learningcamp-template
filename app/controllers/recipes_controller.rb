# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :authenticate_user!

  def index
    @recipes = Recipe.all
  end

  def show; 
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipe.new
  end

  def create
    message = params[:recipe][:ingredients]

    begin
      @recipe = RecipeGeneratorService.new(message, current_user).call
      if @recipe.save
        redirect_to recipes_path, notice: 'Recipe created successfully'
      else
        render :new, status: :unprocessable_entity
      end
    rescue RecipeGeneratorServiceError => e
      @recipe = Recipe.new(recipe_params)
      flash[:alert] = e.message
      render :new, status: :unprocessable_entity
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :description, :ingredients)
  end
end
