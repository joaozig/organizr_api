require 'rails_helper'

RSpec.describe "Lists Requests", type: :request do
  before(:each) do
    @list = FactoryGirl.create(:list, user: FactoryGirl.create(:user))
  end

  context "When not signed in" do
    describe "GET #index" do
      before(:each) do
        get lists_path
      end

      it "respond with http status 401" do
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns Not authenticated error message" do
        expect(json_response[:errors]).to eq("Not authenticated")
      end
    end
  end

  context "When signed in" do
    describe "GET #index" do
      before(:each) do
        @another_user = FactoryGirl.create(:user, email: "another@email.com")
        FactoryGirl.create(:list, { title: "List 2", user: @list.user })
        FactoryGirl.create(:list, { title: "List 3", user: @another_user })

        get lists_path, nil, { "Authentication": @list.user.auth_token }
      end

      it "respond with http status 200" do
        expect(response).to have_http_status(:ok)
      end

      it "returns only the authenticated user's lists on a hash" do
        expect(json_response.count).to eq(2)
      end
    end
  end
end
