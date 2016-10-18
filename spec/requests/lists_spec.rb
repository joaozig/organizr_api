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

    describe "PATCH #update" do
      it "responds with http status 401" do
        patch list_path(1)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "DELETE #destroy" do
      it "responds with http status 401" do
        delete list_path(1)
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

    describe "PATCH #update" do
      before(:each) do
        @list = FactoryGirl.create(:list, { user: @user } )
      end

      context "when is successfully updated" do
        before(:each) do
          patch list_path(@list.id), { list: { title: "Updated title" } }, @authentication_header
        end

        it "respond with http status 200" do
          expect(response).to have_http_status(:ok)
        end

        it "returns the updated list on a hash" do
          expect(json_response[:title]).to eq("Updated title")
        end
      end

      context "when is not updated" do
        context "because validation failed" do
          before(:each) do
            patch list_path(@list.id), { list: { title: "" } }, @authentication_header
          end

          it "respond with http status 422" do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it "returns a json with errors" do
            expect(json_response).to have_key(:errors)
          end

          it "returns why the list could not be updated" do
            expect(json_response[:errors][:title]).to include("can't be blank")
          end
        end

        context "because tried to update a list from another user" do
          before(:each) do
            @another_user = FactoryGirl.create(:user, email: "another@user.com")
            @another_list = FactoryGirl.create(:list, user: @another_user)
            patch list_path(@another_list.id), { list: { title: "Valid title" } }, @authentication_header
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

    describe "DELETE #destroy" do
      before(:each) do
        @list = FactoryGirl.create(:list, user: @user)
      end

      context "when is successfully deleted" do
        it "respond with http status 204" do
          delete list_path(@list.id), nil, @authentication_header
          expect(response).to have_http_status(:no_content)
        end
      end

      context "when is not deleted" do
        context "because tried to delete a list from another user" do
          before(:each) do
              @another_user = FactoryGirl.create(:user, email: "another@user.com")
              @another_list = FactoryGirl.create(:list, user: @another_user)
              delete list_path(@another_list.id), nil, @authentication_header
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
