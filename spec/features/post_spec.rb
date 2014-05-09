require "spec_helper"

feature "Post" do
  background do
    @user = create :user
    login_as(@user, :scope => :user)
    fetch_activity_type('post.create')
    fetch_activity_type('post.update')
    fetch_activity_type('post.destroy')
  end

  scenario "creation", js: true do
    visit posts_path

    click_link 'New Post'

    page.should have_selector("#formID1", :text => "Subject")

    fill_in 'post[subject]', :with => 'My First Post'
    fill_in 'post[content]', :with => 'Content Example'
    click_on 'Save'

    page.should_not have_selector('#new_kyu', visible: true)
    page.should have_content('My First Post')
    Post.count.should == 1
  end

  scenario "Updation", js: true do
    my_post = create :post, user: @user
    updated_content = 'Content Example Update'

    visit post_path(my_post)

    click_link 'Edit'

    page.should have_selector("#formID", :text => "Subject")

    fill_in 'post[content]', :with => updated_content
    click_on 'Save'

    page.should have_selector("#formID")
    page.should have_selector("#kyu-post", :text => updated_content)
  end

  scenario "Deletion" do
    my_post = create :post, user: @user, subject: 'Delete Post Test'

    visit post_path(my_post)
    click_link 'Delete'

    page.should_not have_selector("table.table", :text => 'Delete Post Test')
  end
end
