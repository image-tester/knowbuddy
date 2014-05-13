require "spec_helper"

feature "Sign in" do
  background do
    create(:user, email: 'user@example.com', password: 'password',
      password_confirmation: 'password', name: "User")
  end

  scenario "with correct credentials" do
    visit '/users/sign_in'

    fill_in 'user[email]', with: 'user@example.com'
    fill_in 'user[password]', with: 'password'
    click_on 'Login'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario "with invalid credentials" do
    visit '/users/sign_in'

    fill_in 'user[email]', with: 'user@example.com'
    fill_in 'user[password]', with: 'wrong_password'
    click_on 'Login'

    expect(page).to have_content 'Invalid email or password.'
  end
end
