require 'rails_helper'

RSpec.describe "Items Requests", type: :request do

  context "When not signed in" do
    describe "GET #index" do
      it "responds with http status 401" do
        get list_items_path(list_id: 1)
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
        FactoryGirl.create(:item, { title: "Item 1", list: @list })
        FactoryGirl.create(:item, { title: "Item 2", list: @list })

        @another_user = FactoryGirl.create(:user, email: "another@email.com")
        @another_list = FactoryGirl.create(:list, { title: "List 2", user: @another_user })
        FactoryGirl.create(:item, { title: "Item 3", list: @another_list })

        get list_items_path(list_id: @list.id), nil, @authentication_header
      end

      it "respond with http status 200" do
        expect(response).to have_http_status(:ok)
      end

      it "returns only the items of the passed list_id on a hash" do
        expect(json_response.count).to eq(2)
      end
    end
  end
end
