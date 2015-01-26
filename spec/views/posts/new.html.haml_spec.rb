require 'rails_helper'

describe "posts/new" do
  before do
    @user = create :user
    sign_in @user

    assign(:post, create(:post, subject: "MyString", content: "MyText"))

    assign(:users,
      Kaminari.paginate_array(create_list :user, 5).page(1).per(5)
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
