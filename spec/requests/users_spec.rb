require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe "GET #show" do
  	before(:each) do
  		@user = FactoryGirl.create :user
  		get user_path(id: @user.id)
  	end

    it "respond with http status 200" do
      expect(response).to have_http_status(200)
    end

    it "returns the user on a hash" do
    	user_response = JSON.parse(response.body, symbolize_names: true)
    	expect(user_response[:email]).to eql(@user.email)
    end
  end

end
