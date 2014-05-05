require 'spec_helper'

describe "kyu_entries/show" do
  before :each do
    @user = create :user
    sign_in @user

    assign(:kyu_entry,
      stub_model(KyuEntry,
        subject: "Subject",
        content: "MyText",
        user: @user,
        created_at: Time.now
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
    assert_select "div#kyu-details" do
      assert_select "div#kyu-subject", text: "Subject"
      assert_select "div#kyu-content", text: "MyText"
    end
  end
end