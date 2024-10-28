# frozen_string_literal: true

class PreferencesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_preference, only: %i[show edit update destroy]


  def index
    @preferences = current_user.preferences
    @pagy, @records = pagy(@preferences)
  end

  
  def show; end

  def new
    @preference = Preference.new
  end

  def create
    @preference = current_user.preferences.build(preference_params)

    if @preference.save!
      redirect_to preference_path(@preference), notice: t('views.preferences.create_success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def preference_params
    params.require(:preference).permit(:name, :description, :restriction)
  end

  def set_preference
    @preference = current_user.preferences.find(params[:id])
  end
end
