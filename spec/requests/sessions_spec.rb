require 'rails_helper'

RSpec.describe "Sessions Requests", type: :request do

	describe "POST #create" do
		before(:each) do
			@user = FactoryGirl.create :user
		end

		context "when the credentials are correct" do
			before(:each) do
				credentials = { email: @user.email, password: "123456" }
				post sessions_path, { session: credentials }
			end

			it "respond with http status 200" do
				expect(response).to have_http_status(:ok)
			end

			it "returns the user record corresponding to the given credentials" do
				@user.reload
				expect(json_response[:auth_token]).to eq(@user.auth_token)
			end
		end

		context "when the credentials are incorrect" do
			before(:each) do
				credentials = { email: "invalid e-mail", password: "invalidPassword" }
				post sessions_path, { session: credentials }
			end

			it "respond with http status 422" do
				expect(response).to have_http_status(:unprocessable_entity)
			end

			it "returns a json with an error" do
				expect(json_response[:errors]). to eq("Invalid email or password")
			end
		end
	end

	describe "DELETE #destroy" do
		before(:each) do
			@user = FactoryGirl.create :user
			credentials = { email: @user.email, password: @user.password }
			post sessions_path, { session: credentials }
			delete session_path(json_response[:auth_token])
		end

		it "respond with http status 204" do
			expect(response).to have_http_status(:no_content)
		end
	end
end
