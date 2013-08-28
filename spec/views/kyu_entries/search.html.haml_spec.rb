require 'spec_helper'
require 'sunspot_matchers'
describe "kyu_entries/search" do
  before(:each) do
    @user = User.create(name: 'user1', email: 'test@kiprosh.com', password: 'password',
      password_confirmation: 'password')
    assign(:kyu_entries, Kaminari.paginate_array([
      stub_model(KyuEntry,
        :subject => "Subject",
        :content => "MyText",
        :user_id => @user.id
      ),
      stub_model(KyuEntry,
        :subject => "Subject",
        :content => "MyText",
        :user_id => @user.id
      )
    ]).page(1).per(25))

    @kyu_entry1 = KyuEntry.create(subject: "Subject",content: "MyText",
      user_id: @user.id)
    @kyu_entry2 = KyuEntry.create(subject: "Subject",content: "MyText",
      user_id: @user.id)
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
   @comment = Comment.create(comment: 'awesome', user_id: @user.id,
    kyu_entry_id: @kyu_entry1.id)
    sign_in @user
  end

  it "renders a no search results page" do
    render template: "kyu_entries/search", search: "Tex"
      assert_select ".content" do
        assert_select "#search_error", text: "Sorry no matching results for this search."
      end
  end
end