require 'rails_helper'

RSpec.describe 'Authentication Service' do
  before(:each) do
    allow(Devise).to receive(:friendly_token).and_return("validToken")
    @user = FactoryGirl.create :user
  end

  context "when the token is valid" do
    before(:each) do
      @authorization = Authentication.new(@user.auth_token)
    end

    it "the user is authenticated" do
      expect(@authorization.authenticated?).to be_truthy
    end

    it "#current_user returns the authenticated user" do
      expect(@authorization.current_user.id).to eq(@user.id)
    end
  end

  context "when the token is invalid" do
    before(:each) do
      @authorization = Authentication.new("invalidToken")
    end

    it "the user is not authenticated" do
      expect(@authorization.authenticated?).to be_falsy
    end

    it "#current_user returns nil" do
      expect(@authorization.current_user).to eq(nil)
    end
  end
end
