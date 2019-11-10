require "test_helper"
class MoviesTest < ActionDispatch::IntegrationTest
    def setup
        User.create(email: "test@example.com",password: "password")
    end
  def test_user_can_see_movie_before_login
    # get the home page
    get "/"
    assert_equal 200, status

    # post the login and follow through to the home page
    assert_select "button", "Login"
    assert_select "a", "Register"
    assert_select "h3", text: "MyString"
    assert_select "h6", text: "Shared by:  test@gmail.com"
  end

    def test_share_a_movie
        #must login before
        post "/users/sign_in", params: { user:  { 
            email: "test@example.com",
            password: "password" }
        }
        # get the new movie
        get '/movies/new'
        assert_equal 200, status
        assert_select "legend", text: "Share a Youtube movie"
        post '/movies', params: {
            movie: {
                url: "https://www.youtube.com/watch?v=oZIiq5-RsaA",
                title: "My title"
            }
        }

        follow_redirect!
        assert_equal 200, status
        assert_equal "/movies", path
        assert_select "h3", text: "My title"
        assert_select "h6", text: "Shared by:  test@example.com"
    end

    def test_can_not_shared_movie_without_url
        #must login before
        post "/users/sign_in", params: { user:  { 
            email: "test@example.com",
            password: "password" }
        }
        post '/movies', params: {
            movie: {
                url: "",
                title: "My title"
            }
        }
        assert_select "li", text: "Url can't be blank"
    end

    def test_can_not_see_shared_movie_form_without_login
        get '/movies/new'
        assert_equal 302, status
        follow_redirect!
        assert_equal "/movies", path
    end
end