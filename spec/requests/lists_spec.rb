require 'rails_helper'

RSpec.describe "Lists Requests", type: :request do

  context "When not signed in" do
    describe "GET #index" do
      it "responds with http status 401" do
        get lists_path
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "POST #create" do
      it "responds with http status 401" do
        post lists_path
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context "When signed in" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @authentication_header = { "Authentication": @user.auth_token }
    end

    describe "GET #index" do
      before(:each) do
        @list = FactoryGirl.create(:list, user: @user)
        FactoryGirl.create(:list, { title: "List 2", user: @user })

        @another_user = FactoryGirl.create(:user, email: "another@email.com")
        FactoryGirl.create(:list, { title: "List 3", user: @another_user })

        get lists_path, nil, @authentication_header
      end

      it "respond with http status 200" do
        expect(response).to have_http_status(:ok)
      end

      it "returns only the authenticated user's lists on a hash" do
        expect(json_response.count).to eq(2)
      end
    end

    describe "POST #create" do
      context "when is successfully created" do
        before(:each) do
          @list_attributes = FactoryGirl.attributes_for :list
          @list_attributes[:user] = @user
          post lists_path, { list: @list_attributes }, @authentication_header
        end

        it "respond with http status 201" do
          expect(response).to have_http_status(:created)
        end

        it "returns the created list on a hash" do
          expect(json_response[:title]).to eq(@list_attributes[:title])
          expect(json_response[:user_id]).to eq(@user.id)
        end
      end

      context "when is not created" do
        before(:each) do
          @invalid_list_attributes = { title: "" }
          post lists_path, { list: @invalid_list_attributes }, @authentication_header
        end

        it "respond with http status 422" do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns a json with errors" do
          expect(json_response).to have_key(:errors)
        end

        it "returns why the list could not be created" do
          expect(json_response[:errors][:title]).to include("can't be blank")
        end
      end
    end
  end
end
