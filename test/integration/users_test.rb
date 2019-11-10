require "test_helper"
require 'bcrypt' 
class UsersTest < ActionDispatch::IntegrationTest
  fixtures :users
  def setup
    User.create(email: "test@example.com",password: "password")
  end
  def test_login
    # get the home page
    get "/"
    assert_equal 200, status
    assert_select "button", "Login"
    assert_select "a", "Register"
    # post the login and follow through to the home page
    post "/users/sign_in", params: { user:  { 
        email: "test@example.com",
        password: "password" }
    }
    follow_redirect!
    assert_equal 200, status
    assert_equal "/", path
    assert_select "li", text: "Welcome test@example.com"
    assert_select "a", text: "Share a movie"
    assert_select "a", text: "Log Out"
  end

  def test_sign_up
    get '/users/sign_up'
    assert_equal 200, status
    assert_select "input[type=submit]", value: "Register Account"
    post '/users', params: {
      user: {
        email: "test2@gmail.com",
        password: "password",
        password_confirmation: "password"
      }
    }

    follow_redirect!
    assert_equal 200, status
    assert_equal "/", path
    assert_select "li", text: "Welcome test2@gmail.com"
    assert_select "a", text: "Share a movie"
    assert_select "a", text: "Log Out"
  end
end