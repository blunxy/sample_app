require 'spec_helper'

describe UsersController do
  render_views

  describe "POST 'create'" do

    context "failure" do

      before(:each) do
        @attr = {
          :name => "",
          :email => "",
          :password => "",
          :password_confirmation => ""
        }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end

    end

    context "success" do 

      before(:each) do
        @attr = {
          :name => "JP",
          :email => "blunxy@gmail.com",
          :password => "foobar",
          :password_confirmation => "foobar"
        }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end

    end

  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
  
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign up")
    end

    it "should have a name field" do
      get :new
      response.should have_selector("input", :type => "text", :name => "user[name]")
    end 

    it "should have an email field" do
      get :new
      response.should have_selector("input", :type => "text", :name => "user[email]")
    end 

    it "should have a password field" do
      get :new
      response.should have_selector("input", :type => "password", :name => "user[password]")
    end 

    it "should have a password confirmation field" do
      get :new
      response.should have_selector("input", :type => "password", :name => "user[password_confirmation]")
    end 
      

  end

  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
      get :show, :id => @user.id
    end

    it "should be successful" do

      response.should be_success
    end

    it "should find the right user" do

      assigns(:user).should == @user
    end

    it "should have the right title" do

      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do

      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do

      response.should have_selector("h1>img", :class => "gravatar")
    end



  end

end
