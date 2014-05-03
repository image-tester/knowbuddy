require 'spec_helper'

describe "kyu_entries/edit.html.haml" do
  before :each do
    @user = create :user
    @kyu_entry = create :kyu_entry, user: @user
    sign_in @user

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

  it "renders the edit kyu_entry form" do
    render
    assert_select "form", :action => kyu_entries_path(@kyu_entry), :method => "post" do
      assert_select "input#kyu_entry_subject", :name => "kyu_entry[subject]"
      assert_select "textarea#textarea_kyu_content", :name => "kyu_entry[content]"
    end
  end
end