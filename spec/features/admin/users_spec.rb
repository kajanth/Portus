require "rails_helper"

feature "Admin - Users panel" do
  let!(:registry) { create(:registry) }
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }

  before do
    login_as admin
    visit admin_users_path
  end

  describe "disable users" do
    scenario "allows the admin to disable other users", js: true do
      expect(page).to have_css("#user_#{user.id}")
      find("#user_#{user.id} .enabled-btn").click

      wait_for_effect_on("#user_#{user.id}")

      expect(page).to have_css("#user_#{user.id} .fa-toggle-off")
      wait_for_effect_on("#alert")
      expect(page).to have_content("User '#{user.username}' has been disabled.")
    end

    scenario "allows the admin to enable back a user", js: true do
      user.update_attributes(enabled: false)
      visit admin_users_path

      expect(page).to have_css("#user_#{user.id}")
      find("#user_#{user.id} .enabled-btn").click

      wait_for_effect_on("#user_#{user.id}")

      expect(page).to have_css("#user_#{user.id} .fa-toggle-on")
      wait_for_effect_on("#alert")
      expect(page).to have_content("User '#{user.username}' has been enabled.")
    end
  end

  describe "toggle admin" do
    scenario "allows the admin to toggle a regular user into becoming an admin", js: true do
      expect(page).to have_css("#user_#{user.id}")
      expect(page).to have_css("#user_#{user.id} .admin-btn .fa-toggle-off")
      find("#user_#{user.id} .admin-btn").click

      wait_for_effect_on("#alert")

      expect(page).to_not have_css("#user_#{user.id} .admin-btn .fa-toggle-off")
      expect(page).to have_css("#user_#{user.id} .admin-btn .fa-toggle-on")
      expect(page).to have_content("User '#{user.username}' is now an admin")
    end

    scenario "allows the admin to remove another admin", js: true do
      user.update_attributes(admin: true)
      visit admin_users_path

      expect(page).to have_css("#user_#{user.id}")
      expect(page).to have_css("#user_#{user.id} .admin-btn .fa-toggle-on")
      find("#user_#{user.id} .admin-btn").click

      wait_for_effect_on("#alert")

      expect(page).to_not have_css("#user_#{user.id} .admin-btn .fa-toggle-on")
      expect(page).to have_css("#user_#{user.id} .admin-btn .fa-toggle-off")
      expect(page).to have_content("User '#{user.username}' is no longer an admin")
    end
  end
end
