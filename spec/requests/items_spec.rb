require 'rails_helper'

RSpec.describe "Items Requests", type: :request do

  context "When not signed in" do
    describe "GET #index" do
      it "responds with http status 401" do
        get list_items_path(list_id: 1)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "POST #create" do
      it "responds with http status 401" do
        post list_items_path(list_id: 1)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context "When signed in" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @list = FactoryGirl.create(:list, user: @user)
      @authentication_header = { "Authentication": @user.auth_token }
    end

    describe "GET #index" do
      before(:each) do
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

    describe "POST #create" do
      context "when is successfully created" do
        before(:each) do
          @item_attributes = FactoryGirl.attributes_for :item
          @item_attributes[:list] = @list
          post list_items_path(list_id: @list.id), { item: @item_attributes }, @authentication_header
        end

        it "respond with http status 201" do
          expect(response).to have_http_status(:created)
        end

        it "returns the created list on a hash" do
          expect(json_response[:title]).to eq(@item_attributes[:title])
          expect(json_response[:list_id]).to eq(@list.id)
        end
      end

      context "when is not created" do
        context "because validation failed" do
          before(:each) do
            @invalid_item_attributes = { title: "" }
            post list_items_path(list_id: @list.id), { item: @invalid_item_attributes }, @authentication_header
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

        context "because tried to create an item to a list from another user" do
          before(:each) do
            @another_user = FactoryGirl.create(:user, email: "another@user.com")
            @another_list = FactoryGirl.create(:list, user: @another_user)
            @item_attributes = FactoryGirl.attributes_for :item
            post list_items_path(@another_list.id), { item: @item_attributes }, @authentication_header
          end

          it "respond with http status 401" do
            expect(response).to have_http_status(:unauthorized)
          end

          it "returns a json with errors" do
            expect(json_response).to have_key(:errors)
          end

          it "returns Permission Denied error message" do
            expect(json_response[:errors]).to include("Permission denied")
          end
        end
      end
    end
  end
end
