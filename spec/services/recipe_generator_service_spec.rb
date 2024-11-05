require 'rails_helper'

RSpec.describe RecipeGeneratorService, type: :service do
  let(:message) { "Generate a recipe for a chocolate cake." }
  let(:user_id) { 1 }
  let(:service) { described_class.new(message, user_id) }

  describe '#call' do
    context 'when the API call is successful' do
      before do
        allow_any_instance_of(OpenAI::Client).to receive(:chat).and_return(OpenStruct.new(body: { 'choices' => [{ 'message' => { 'content' => 'Recipe content' } }] }))
      end

      it 'returns a successful response' do
        expect { service.call }.not_to raise_error
      end
    end

    context 'when the API call is unauthorized' do
      before do
        allow_any_instance_of(OpenAI::Client).to receive(:chat).and_raise(Faraday::UnauthorizedError)
      end

      it 'raises a RecipeGeneratorServiceError' do
        expect { service.call }.to raise_error(RecipeGeneratorServiceError, I18n.t('api.errors.unauthorized'))
      end
    end
  end
end
