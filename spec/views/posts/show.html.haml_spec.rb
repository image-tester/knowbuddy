require 'rails_helper'

describe "posts/show" do
  before :each do
    @user = create :user
    post = create(:post, subject: "Subject", content: "MyText",
     user: @user, created_at: Time.now, updated_at: Time.now )
    sign_in @user
    assign(:post, post)
    assign(:users,
      Kaminari.paginate_array(create_list :user, 5).page(1).per(5)
      )
  end

  it "renders attributes in a div" do
    render
    assert_select "div#post-details" do
      assert_select "div#post-subject", text: "Subject"
      assert_select "div#post-content", text: "MyText"
    end
  end
end
