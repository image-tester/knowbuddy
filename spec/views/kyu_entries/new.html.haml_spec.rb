require 'spec_helper'

describe "kyu_entries/new" do
  before(:each) do
    assign(:kyu_entry, stub_model(KyuEntry,
      :subject => "MyString",
      :content => "MyText"
    ).as_new_record)
  end

  it "renders new kyu_entry form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => kyu_entries_path, :method => "post" do
      assert_select "input#kyu_entry_subject", :name => "kyu_entry[subject]"
      assert_select "textarea#kyu_entry_content", :name => "kyu_entry[content]"
    end
  end
end
