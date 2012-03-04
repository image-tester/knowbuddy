require 'spec_helper'

describe "kyu_entries/show" do
  before(:each) do
    @kyu_entry = assign(:kyu_entry, stub_model(KyuEntry,
      :subject => "Subject",
      :content => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Subject/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
