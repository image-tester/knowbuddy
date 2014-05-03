require 'spec_helper'

describe "kyu_entries/new" do
  before do
    @user = create :user
    sign_in @user

    assign(:kyu_entry, stub_model(KyuEntry,
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

  it "renders new kyu_entry form" do
    render
    assert_select "form", action: kyu_entries_path, method: "post" do
      assert_select "input#kyu_entry_subject", name: "kyu_entry[subject]"
      assert_select "textarea#textarea_kyu_content", name: "kyu_entry[content]"
    end
  end
end