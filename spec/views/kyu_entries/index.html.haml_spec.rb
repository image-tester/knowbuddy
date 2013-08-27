require 'spec_helper'

describe "kyu_entries/index" do
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

    @kyu_entry1 = KyuEntry.create(subject: "Subject",content: "MyText", user_id: @user.id)
    @kyu_entry2 = KyuEntry.create(subject: "Subject",content: "MyText", user_id: @user.id)

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
    sign_in @user
  end

  it "renders a list of kyu_entries" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr.odd td", :text => "Subject"
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end