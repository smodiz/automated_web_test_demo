require 'spec_helper'

describe 'create flash card via the API' do

  let(:deck) { FactoryGirl.create(:deck) }

  context 'with valid data' do
    it 'successfully creates a flash card' do
      flash_card = FactoryGirl.build(:flash_card, deck: deck)

      response = RestClient.post(
        flash_card_api_url,
        { flash_card: flash_card.attributes },
        Authorization: "Token token=#{UserAuth.auth_token}")
      flash_card_response = JSON.parse(
        response.body,
        symbolize_names: true)[:flash_card]

      expect(response.code).to eq 201
      expect(flash_card_response[:front]).to eq flash_card.front
      expect(flash_card_response[:back]).to eq flash_card.back
      expect(flash_card_response[:sequence]).to eq flash_card.sequence
      expect(flash_card_response[:difficulty]).to eq flash_card.difficulty
    end
  end

  context 'without required fields' do
    it 'returns error for each missing required fields' do
      invalid_flash_card = FactoryGirl.build(
        :flash_card, deck: deck, difficulty: '', front: '', back: '', sequence: '')
      expected_errors = [
        "Front can't be blank",
        "Back can't be blank",
        'Difficulty is not included in the list'
        # sequence is an optional field, so no err msg expected
      ]

      begin
        RestClient.post(
          flash_card_api_url,
          { flash_card: invalid_flash_card.attributes },
          Authorization: "Token token=#{UserAuth.auth_token}")
      rescue RestClient::UnprocessableEntity => err
        errors = JSON.parse(err.response, symbolize_names: true)[:flash_cards]
      end

      expect(errors).to match_array expected_errors
    end
  end

  private

  def flash_card_api_url
    @url ||= UrlBuilder.url_for('api/v1/flash_cards')
  end
end
