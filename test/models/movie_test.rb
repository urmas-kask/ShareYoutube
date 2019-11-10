require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  fixtures :users
  test "url không được để trống" do
    movie = Movie.new(url: "")
    assert movie.invalid?
    assert movie.errors[:url].any?
    assert_equal ["can't be blank"], movie.errors[:url]
  end
end