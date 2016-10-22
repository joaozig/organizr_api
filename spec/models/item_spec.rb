require 'rails_helper'

RSpec.describe Item, type: :model do
	before(:each) do
		@list = FactoryGirl.build(:list)
		@item = FactoryGirl.build(:item, list: @list)
	end

  subject { @item }

  it { should respond_to(:title) }
  it { should respond_to(:due_date) }
  it { should respond_to(:list) }

  it { should be_valid }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:list) }
end
