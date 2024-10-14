# frozen_string_literal: true

class PreferencesController < ApplicationController
  def index
    @preferences = current_user.preferences
    @pagy, @records = pagy(@preferences)
  end

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

  def update
    if @preference.update!(preference_params)
      redirect_to preference_path(@preference), notice: t('views.preferences.update_success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @preference.destroy!
      redirect_to preferences_path, notice: t('views.preferences.destroy_success')
    else
      redirect_to preferences_path, alert: t('views.preferences.destroy_failure')
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
