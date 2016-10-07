require 'rails_helper'

RSpec.describe "Users Requests", type: :request do

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
    	expect(user_response[:email]).to eq(@user.email)
    end
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post users_path, { user: @user_attributes }
      end

      it "respond with http status 201" do
        expect(response).to have_http_status(201)
      end

      it "returns the created user on a hash" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eq(@user_attributes[:email])
      end
    end

    context "when is not created" do
      before(:each) do
        @invalid_user_attributes = { password: "123456", password_confirmation: "123456" }
        post users_path, { user: @invalid_user_attributes }
      end

      it "respond with http status 422" do
        expect(response).to have_http_status(422)
      end

      it "returns a json with errors" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it "returns why the user could not be created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include("can't be blank")
      end
    end
  end

  describe "PATCH #update" do
    context "when is successfully updated" do
      before(:each) do
        @user = FactoryGirl.create :user
        patch user_path(id: @user.id), { user: { email: "new@email.com" } }
      end

      it "respond with http status 200" do
        expect(response).to have_http_status(200)
      end

      it "returns the updated user on a hash" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eq("new@email.com")
      end
    end

    context "when is not updated" do
      before(:each) do
        @user = FactoryGirl.create :user
        patch user_path(id: @user.id), {user: { email: "bademail.com" } }
      end

      it "respond with http status 422" do
        expect(response).to have_http_status(422)
      end

      it "returns a json with errors" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it "returns why the user could not be updated" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include("is invalid")
      end
    end
  end
end
