require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end 

  it "should have a Contact page at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => "Contact")
  end

  it "should have an About page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => "About")
  end 

  it "should have an Signin page at '/signin'" do
    get '/signin'
    response.should have_selector('title', :content => "Sign in")
  end 

  it "should have the right links on the layout" do
    visit root_path

    click_link "About"
    response.should have_selector('title', :content => "About")

    click_link "Contact"
    response.should have_selector('title', :content => "Contact")

    click_link "Sign in"
    response.should have_selector('title', :content => "Sign in")
  end

end
