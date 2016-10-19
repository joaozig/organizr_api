require 'rails_helper'

RSpec.describe "Users Requests", type: :request do

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post users_path, { user: @user_attributes }
      end

      it "respond with http status 201" do
        expect(response).to have_http_status(:created)
      end

      it "returns the created user on a hash" do
        expect(json_response[:email]).to eq(@user_attributes[:email])
      end
    end

    context "when is not created" do
      before(:each) do
        @invalid_user_attributes = { password: "123456", password_confirmation: "123456" }
        post users_path, { user: @invalid_user_attributes }
      end

      it "respond with http status 422" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns a json with errors" do
        expect(json_response).to have_key(:errors)
      end

      it "returns why the user could not be created" do
        expect(json_response[:errors][:email]).to include("can't be blank")
      end
    end
  end

  context "when not signed in" do
    describe "GET #show" do
      it "responds with http status 401" do
        get user_path(1)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "PATCH #update" do
      it "responds with http status 401" do
        patch user_path(1)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "DELETE #destroy" do
      it "responds with http status 401" do
        delete user_path(1)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context "when signed in" do
    before(:each) do
      @user = FactoryGirl.create :user
      @authentication_header = { "Authentication": @user.auth_token }
    end

    describe "GET #show" do
      context "when is own user" do
        before(:each) do
          get user_path(id: @user.id), nil, @authentication_header
        end

        it "respond with http status 200" do
          expect(response).to have_http_status(:ok)
        end

        it "returns the user on a hash" do
          expect(json_response[:email]).to eq(@user.email)
        end
      end

      context "when is not own user" do
        before(:each) do
          @another_user = FactoryGirl.create(:user, email: 'other@email.com')
          get user_path(id: @another_user.id), nil, @authentication_header
        end

        it "respond with http status 401" do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    describe "PATCH #update" do
      context "when is successfully updated" do
        before(:each) do
          patch user_path(id: @user.id), { user: { email: "new@email.com" } }, @authentication_header
        end

        it "respond with http status 200" do
          expect(response).to have_http_status(:ok)
        end

        it "returns the updated user on a hash" do
          expect(json_response[:email]).to eq("new@email.com")
        end
      end

      context "when is not updated" do
        before(:each) do
          patch user_path(id: @user.id), {user: { email: "bademail.com" } }, @authentication_header
        end

        it "respond with http status 422" do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns a json with errors" do
          expect(json_response).to have_key(:errors)
        end

        it "returns why the user could not be updated" do
          expect(json_response[:errors][:email]).to include("is invalid")
        end
      end
    end

    describe "DELETE #destroy" do
      before(:each) do
        delete user_path(@user.id), nil, @authentication_header
      end

      it "respond with http status 204" do
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
