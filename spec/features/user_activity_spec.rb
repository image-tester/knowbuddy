require "rails_helper"

feature "Sign Up" do
  background do
    fetch_activity_type('user.create')
  end

  scenario "should add user activity" do
    visit '/users/sign_up'

    fill_in 'user[name]', with: 'John'
    fill_in 'user[email]', with: 'user@example.com'
    fill_in 'user[password]', with: 'password'
    fill_in 'user[password_confirmation]', with: 'password'

    click_on 'Sign up'

    expect(page).to have_content 'You have signed up successfully.'

    expect(User.last.activities.count).to eq 1
    expect(page).to have_selector(".block2", text: "John just joined KnowBuddy.")
  end
end
