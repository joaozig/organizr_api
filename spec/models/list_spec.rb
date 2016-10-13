require 'rails_helper'

RSpec.describe List, type: :model do
	before(:each) do
		@user = FactoryGirl.build(:user)
		@list = FactoryGirl.build(:list, user: @user)
	end

  subject { @list }

  it { should respond_to(:title) }
  it { should respond_to(:user) }

  it { should be_valid }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:user) }
end
