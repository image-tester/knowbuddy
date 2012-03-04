require 'spec_helper'

describe "kyu_entries/edit" do
  before(:each) do
    @kyu_entry = assign(:kyu_entry, stub_model(KyuEntry,
      :subject => "MyString",
      :content => "MyText"
    ))
  end

  it "renders the edit kyu_entry form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => kyu_entries_path(@kyu_entry), :method => "post" do
      assert_select "input#kyu_entry_subject", :name => "kyu_entry[subject]"
      assert_select "textarea#kyu_entry_content", :name => "kyu_entry[content]"
    end
  end
end
