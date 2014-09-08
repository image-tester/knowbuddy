require 'spec_helper'

describe "posts/show" do
  before :each do
    @user = create :user
    sign_in @user

    assign(:post,
      stub_model(Post,
        subject: "Subject",
        content: "MyText",
        user: @user,
        created_at: Time.now,
        updated_at: Time.now
      ))
    assign(:users,
      Kaminari.paginate_array([stub_model(User, name: "xyz",
        email: 'test@kiprosh.com',
        password: 'password',
        password_confirmation: 'password'),
      stub_model(User, name: "xyz",
        email: 'test@kiprosh.com',
        password: 'password',
        password_confirmation: 'password')]).page(1).per(5)
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
