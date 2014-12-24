require 'rails_helper'

describe "posts/new" do
  before do
    @user = create :user
    sign_in @user

    assign(:post, stub_model(Post,
      subject: "MyString",
      content: "MyText"
    ).as_new_record)

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

  it "renders new post form" do
    render
    assert_select "form", action: posts_path, method: "post" do
      assert_select "input#post_subject", name: "post[subject]"
      assert_select "textarea#textarea_post_content", name: "post[content]"
    end
  end
end
