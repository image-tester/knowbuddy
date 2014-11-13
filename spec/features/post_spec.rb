require "spec_helper"

feature "Post" do
  background do
    @user = create :user
    login_as(@user, scope: :user)
    fetch_activity_type('post.create')
    fetch_activity_type('post.update')
    fetch_activity_type('post.destroy')
    fetch_activity_type('post.like')
    fetch_activity_type('post.dislike')
  end

  scenario "Creation", js: true do
    visit posts_path

    click_link 'New Post'

    expect(page).to have_selector("#new_post", text: "New Post")

    fill_in 'post[subject]', with: 'My First Post'
    fill_in 'post[content]', with: 'Content Example'
    click_on 'Publish'

    expect(page).to have_selector('#new_post', visible: false)
    expect(page).to have_content 'My First Post'
    Post.last.subject == 'My First Post'
    Post.last.is_draft == false
  end

  scenario "Draft Creation", js: true do
    visit posts_path

    click_link 'New Post'

    expect(page).to have_selector("#new_post")

    fill_in 'post[subject]', with: 'My First Draft'
    fill_in 'post[content]', with: 'Content Example'
    click_on 'save_as_draft_button'

    expect(page).to have_selector('#new_post', visible: true)
    expect(page).to have_selector('#loading', visible: false)
    expect(page).to have_selector('.draft', visible: true)
    Post.last.subject == 'My First Draft'
    Post.last.is_draft == true

    visit draft_list_posts_path
    expect(page).to have_content 'My First Draft'
  end

  scenario "Updation", js: true do
    my_post = create :post, user: @user
    updated_content = 'Content Example Update'

    visit post_path(my_post)

    click_link 'Edit'

    expect(page).to have_selector("#edit_post_form", text: "Subject")

    fill_in 'post[content]', with: updated_content
    click_on 'Publish'

    page.assert_no_selector("#edit_post_form")
    expect(page).to have_selector("#post-post", text: updated_content)
  end

  scenario "Deletion" do
    my_post = create :post, user: @user, subject: 'Delete Post Test'

    visit post_path(my_post)
    click_link 'Delete'

    expect(page).not_to have_selector("table.table", text: 'Delete Post Test')
  end

  scenario "Show" do
    my_post = create :post, user: @user, subject: 'Content Example'
    visit post_path(my_post)

    expect(page).to have_selector("#post-subject", text: 'Content Example')
    expect(page).to have_selector(:link_or_button, 'Edit')
    expect(page).to have_selector(:link_or_button, 'Delete')
  end

  scenario "like post", js: true do
    my_post = create :post
    visit post_path(my_post)
    find('i#like').click
    expect(page).to have_selector(".up_rate .vote", text: "1")

    visit posts_path
    expect(page).to have_selector("table#activity",
      text: "#{@user.name.titleize} liked an article #{my_post}")

    expect(my_post.get_likes.size).to eq(1)
  end

  scenario "like post", js: true do
    my_post = create :post
    visit post_path(my_post)
    find('i#dislike').click
    expect(page).to have_selector(".down_rate .vote", text: "1")

    visit posts_path
    expect(page).to have_selector("table#activity",
      text: "#{@user.name.titleize} disliked an article #{my_post}")

    expect(my_post.get_dislikes.size).to eq(1)
  end
end
