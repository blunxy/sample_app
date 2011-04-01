require 'spec_helper'

describe User do

  before(:each) do
    @attr = { 
      :name => "Example User", 
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    valid_addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    valid_addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    invalid_addresses = %w[user@foo,com THE_USER.foo.bar.org first.last@foo.]
    invalid_addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr);
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject emails with same letters but different cases" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end


  context "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "")).should_not be_valid
    end
    
    it "should require a confirmation password" do
      User.new(@attr.merge(:password_confirmation => "")).should_not be_valid
    end

    it "should require a matching confirmation password" do
      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end

    it "should reject short passwords" do
      short_password = "a" * 5
      attributes = @attr.merge(:password => short_password, :password_confirmation => short_password)
      User.new(attributes).should_not be_valid
    end

    it "should reject long passwords" do
      long_password = "a" * 41
      attributes = @attr.merge(:password => long_password, :password_confirmation => long_password)
      User.new(attributes).should_not be_valid
    end

  end

  context "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    context "has_password? method" do

      it "should be true if the password match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should be false if the passwords don't match" do
        @user.has_password?("foonuckle").should be_false
      end

    end

    context "authenticate method" do

      it "should return nil on user not in system" do
        not_in_system_user = User.authenticate("fnargle@g.com", @attr[:password])
        not_in_system_user.should be_nil
      end

      it "should return nil on password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "fnargle")
        wrong_password_user.should be_nil
      end

      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end

    end

  end

end
