require 'spec_helper'

describe "lists/index" do
  before :each do
    @category = FactoryGirl.create :category, :name => 'Category Name', :position => 7
    @list = FactoryGirl.create :list, :category => @category
    @user = FactoryGirl.create :user
    assign(:categories, [@list.category])
    assign(:user, @user)
  end

  it "renders name" do
    render
    rendered.should match("Category Name")
  end

  it "should have subscribers_count span" do
    FactoryGirl.create(:list, :subscribers => [@user.subscriber], :category => @list.category)
    render
    rendered.should have_selector(".subscribers_count", :count => 2)
  end
end

describe "lists/edit" do
  it "renders the form links" do
    create_list_and_user
    render
    rendered.should match(change_description_path)
    rendered.should match(change_category_path)
    rendered.should match(add_subscribers_to_list_path)
    rendered.should match(remove_from_list_path)
  end

  it "restricts access if you are not part of a restricted list" do
    create_list_and_user true
    render
    rendered.should match(change_description_path)
    rendered.should_not match(add_subscribers_to_list_path)
    rendered.should_not match(remove_from_list_path)
  end

  it "does not restrict access if you are part of a restricted list" do
    create_list_and_user true, true
    render
    rendered.should match(add_subscribers_to_list_path)
    rendered.should match(remove_from_list_path)
  end

  def create_list_and_user restricted=false, subscriber=false
    @user = FactoryGirl.create(:user)
    @list = FactoryGirl.create(:list, :restricted => restricted)
    @list.subscribers << @user.subscriber if subscriber
    assign(:list, @list)
    assign(:user, @user)
  end

end
