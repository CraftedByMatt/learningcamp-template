# frozen_string_literal: true

class RecipeGeneratorService
  attr_reader :message, :user

  OPENAI_TEMPERATURE = ENV.fetch('OPENAI_TEMPERATURE', 0).to_f
  OPENAI_MODEL = ENV.fetch('OPENAI_MODEL', 'gpt-3.5-turbo')

  def initialize(message, user)
    @message = message
    @user = user
    @preferences = find_preferences
    @openai_client = OpenAI::Client.new(api_key: ENV['OPENAI_API_KEY'])
  end

  def call
    check_valid_message_length
    response = message_to_chat_api
    create_recipe(response)
  end

  private

  def find_preferences
    ::Preference.all.where(user_id: @user.id)
  end

  def parse_preferences
    @preferences = @preferences.map do |preference|
      {
        name: preference.name,
        description: preference.description,
        restriction: preference.restriction
      }
    end
  end

  def check_valid_message_length
    error_msg = I18n.t('api.errors.invalid_message_length')
    raise RecipeGeneratorServiceError, error_msg unless !!(message =~ /\b\w+\b/)
  end

  def message_to_chat_api
    openai_client.chat(parameters: {
                         model: OPENAI_MODEL,
                         messages: request_messages,
                         temperature: OPENAI_TEMPERATURE
                       })
  end

  def request_messages
    system_message + new_message
  end

  def system_message
    [{ role: 'system', content: prompt }]
  end

  def prompt
    <<~CONTENT
      You are a recipe generator. Given a list of ingredients and taking into account if ingredients in user preferences are restricted, generate a complete recipe, if restrictions exists generate a new recipe without that ingredient.  following this JSON format:
      {
        "name": Dish Name,
        "content": Recipe instructions,
        "ingredients": "List of ingredients"
      }
      Preferences: #{parse_preferences}
      Ingredients: #{@message}
    CONTENT
  end

  def new_message
    [
      { role: 'user', content: "Ingredients: #{message}" }
    ]
  end

  def openai_client
    @openai_client ||= OpenAI::Client.new
  end

  def create_recipe(response)
    parsed_response = response.is_a?(String) ? JSON.parse(response) : response
    content = JSON.parse(parsed_response.dig('choices', 0, 'message', 'content'))
    Recipe.create!(name: content['name'], description: content['content'], ingredients: content['ingredients'], user: @user)
  rescue JSON::ParserError => exception
    raise RecipeGeneratorServiceError, exception.message
  end
end
