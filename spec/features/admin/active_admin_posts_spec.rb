require "rails_helper"

feature "Admin-Posts" do
  before do
    admin_user = create(:admin_user)
    login_as(admin_user, scope: :admin_user)
    fetch_activity_type("post.create")
    fetch_activity_type("post.update")
    @post = create(:post)
  end

  scenario "Marking post as internal", js: true do
    visit admin_posts_path
    expect(page).to have_content(@post.subject)
    within("#post_#{@post.id} .col-internal") do
      expect(page).to have_content("NO")
    end
    within("#post_#{@post.id}") do
      click_link("Edit")
    end
    check("Is internal")
    click_button("Update Post")
    within("#tabs #posts") do
      click_link("Posts")
    end
    within("#post_#{@post.id} .col-internal") do
      expect(page).to have_content("YES")
    end
  end
end
