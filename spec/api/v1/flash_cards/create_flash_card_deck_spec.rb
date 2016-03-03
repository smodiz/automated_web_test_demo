require 'spec_helper'

describe 'create flash card deck' do
  before(:each) do
    @user = User.find_by(email: ENV['QN_USER'])
    @auth_token = @user.authentication_token
    @decks_api_url = UrlBuilder.url_for('api/v1/decks')
  end

  context 'with valid data' do
    it 'successfully creates a flash card deck' do
      @attributes =
      {
        name: 'Lolapalooza',
        description: 'All about Lola',
        status: 'Private',
        tag_list: 'ruby'
      }
      response = RestClient.post @decks_api_url,
                                 { deck: @attributes },
                                 Authorization: "Token token=#{@auth_token}"
      deck = JSON.parse(response.body, symbolize_names: true)[:deck]

      expect(response.code).to eq 201
      expect(deck[:name]).to eq @attributes[:name]
      expect(deck[:description]).to eq @attributes[:description]
      expect(deck[:status]).to eq @attributes[:status]
      expect(deck[:tags].first[:name]).to eq @attributes[:tag_list]
    end
  end

  context 'without required fields' do
    it 'sends an error back for each missing required field' do
      @attributes =
      {
        name: '',
        description: '',
        status: ''
      }
      expected_errors = [
        "Name can't be blank",
        "Description can't be blank",
        "Status can't be blank",
        'Status is not included in the list'
      ]
      begin
        RestClient.post @decks_api_url,
                        { deck: @attributes },
                        Authorization: "Token token=#{@auth_token}"
      rescue RestClient::UnprocessableEntity => err
        errors = JSON.parse(err.response, symbolize_names: true)[:decks]
      end
      expect(errors).to match_array expected_errors
    end
  end
end
