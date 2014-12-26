require 'rails_helper'

describe "posts/edit.html.haml" do
  before :each do
    @user = create :user
    @post = create :post, user: @user
    sign_in @user

    assign(:users,
      Kaminari.paginate_array(create_list :user, 5).page(1).per(5)
    )
  end

  it "renders the edit post form" do
    render
    assert_select "form", :action => posts_path(@post), :method => "post" do
      assert_select "input#post_subject", :name => "post[subject]"
      assert_select "textarea#textarea_post_content", :name => "post[content]"
    end
  end
end
