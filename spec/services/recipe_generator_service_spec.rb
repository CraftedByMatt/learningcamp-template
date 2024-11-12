require 'rails_helper'

RSpec.describe RecipeGeneratorService do
  let(:user) { create(:user) }
  let!(:preferences) { create_list(:preference, 3, user: user) }
  let(:service) { described_class.new('some message', user) }

  describe '#call' do
    context 'when the API call is unauthorized' do
      it 'raises a RecipeGeneratorServiceError' do
        allow(service).to receive(:message_to_chat_api).and_raise(RecipeGeneratorServiceError, I18n.t('api.errors.unauthorized'))
        expect { service.call }.to raise_error(RecipeGeneratorServiceError, I18n.t('api.errors.unauthorized'))
      end
    end

    context 'when the API call is successful' do
      it 'returns a successful response' do
        mock_response = {
          'choices' => [
            {
              'message' => {
                'content' => {
                  'name' => 'Test Dish',
                  'content' => 'Test Recipe Instructions',
                  'ingredients' => 'Test Ingredients'
                }.to_json
              }
            }
          ]
        }
        allow(service).to receive(:message_to_chat_api).and_return(mock_response)
        expect { service.call }.not_to raise_error
      end
    end
  end
end
