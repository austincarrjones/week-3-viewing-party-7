require 'rails_helper'

RSpec.describe "Logging In" do
  it "can log in with valid credentials" do
    user = User.create(name: 'Meg', email: 'meg@test.com', password: 'password123', password_confirmation: 'password123')

    visit root_path

    click_on "Log In"

    expect(current_path).to eq(login_path)

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_on "Log In"

    expect(current_path).to eq(user_path(user.id))

    expect(page).to have_content("Welcome, #{user.name}")
  end

  it "cannot log in with bad credentials" do
    user = User.create(name: 'Meg', email: 'meg@test.com', password: 'password123', password_confirmation: 'password123')
  
    visit login_path
    
    fill_in :email, with: user.email
    fill_in :password, with: "incorrect password"
  
    click_on "Log In"
  
    expect(current_path).to eq(login_path)
  
    expect(page).to have_content("Sorry, your credentials are bad.")
  end

  describe "location cookie" do 
    it "shows text field for Location, enter my city and state, log in, see my location on the landing page" do
      user = User.create(name: 'Meg', email: 'meg@test.com', password: 'password123', password_confirmation: 'password123')
    
      visit login_path
      
      fill_in :email, with: user.email
      fill_in :password, with: "password123"
      fill_in :location, with: "Denver, CO"
    
      click_on "Log In"
      save_and_open_page
      expect(current_path).to eq(user_path(user.id))

      expect(page).to have_content("Denver, CO")
    end

    it "prefills location field with previous response after logging out and trying login again" do
      user = User.create(name: 'Meg', email: 'meg@test.com', password: 'password123', password_confirmation: 'password123')
      
      visit login_path
      
      fill_in :email, with: user.email
      fill_in :password, with: "password123"
      fill_in :location, with: "Denver, CO"
    
      click_on "Log In"
    
      visit login_path

      click_on "Log Out"
    end
  end
end