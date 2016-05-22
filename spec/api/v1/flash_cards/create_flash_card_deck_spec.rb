require 'spec_helper'

describe 'create flash card deck via the API' do

  context 'with valid data' do
    it 'successfully creates a flash card deck' do
      deck = FactoryGirl.build(:deck)
      tag = FactoryGirl.build(:tag)

      response = RestClient.post(
        decks_api_url,
        { deck: deck.attributes.merge(tag_list: tag.name) },
        Authorization: "Token token=#{UserAuth.auth_token}")
      response_deck = JSON.parse(response.body, symbolize_names: true)[:deck]

      expect(response.code).to eq 201
      expect(response_deck[:name]).to eq deck.name
      expect(response_deck[:description]).to eq deck.description
      expect(response_deck[:status]).to eq deck.status
      expect(response_deck[:tags].first[:name]).to eq tag.name
    end
  end

  context 'without required fields' do
    it 'sends an error back for each missing required field' do
      deck = FactoryGirl.build(:deck, name: '', description: '', status: '')
      expected_errors = [
        "Name can't be blank",
        "Description can't be blank",
        "Status can't be blank",
        'Status is not included in the list'
      ]

      begin
        RestClient.post decks_api_url,
                        { deck: deck.attributes },
                        Authorization: "Token token=#{UserAuth.auth_token}"
      rescue RestClient::UnprocessableEntity => err
        errors = JSON.parse(err.response, symbolize_names: true)[:decks]
      end

      expect(errors).to match_array expected_errors
    end
  end

  private

  def decks_api_url
    @url ||= UrlBuilder.url_for('api/v1/decks')
  end
end
