require 'spec_helper'

describe 'create flash card via the API' do
  before(:each) do
    @user = User.find_by(email: ENV['QN_USER'])
    @auth_token = @user.authentication_token
    @deck = TestDataFactory::TestDeck.create(
      { name: 'Lola the Schnauzer', description: 'All about Lola' },
      @user)
    @flash_card_api_url = UrlBuilder.url_for('api/v1/flash_cards')
  end

  context 'with valid data' do
    it 'successfully creates a flash card' do
      @attributes = {
        front: 'Who does Lola bark at almost every day?',
        back: 'The mailman',
        sequence: 1,
        difficulty: '2',
        deck_id: @deck.id
      }
      response = RestClient.post(
        @flash_card_api_url,
        { flash_card: @attributes },
        Authorization: "Token token=#{@auth_token}")
      flash_card = JSON.parse(
        response.body,
        symbolize_names: true)[:flash_card]

      expect(response.code).to eq 201
      expect(flash_card[:front]).to eq @attributes[:front]
      expect(flash_card[:back]).to eq @attributes[:back]
      expect(flash_card[:sequence]).to eq @attributes[:sequence]
      expect(flash_card[:difficulty]).to eq @attributes[:difficulty]
    end
  end

  context 'without required fields' do
    it 'returns error for each missing required fields' do
      @attributes = {
        front: '',
        back: '',
        sequence: '',
        difficulty: '',
        deck_id: @deck.id
      }
      expected_errors = [
        "Front can't be blank",
        "Back can't be blank",
        'Difficulty is not included in the list'
        # sequence is an optional field and should not produce error
      ]
      begin
        RestClient.post(
          @flash_card_api_url,
          { flash_card: @attributes },
          Authorization: "Token token=#{@auth_token}")
      rescue RestClient::UnprocessableEntity => err
        errors = JSON.parse(err.response, symbolize_names: true)[:flash_cards]
      end
      expect(errors).to match_array expected_errors
    end
  end
end
