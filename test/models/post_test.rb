require "test_helper"

class PostTest < ActiveSupport::TestCase
  def setup
    @post1 = posts(:one)
    @post2 = posts(:two)
  end

  test "should be valid" do
    assert @post1.valid?
    assert @post2.valid?
  end

  test "title should be present" do
    assert @post1.title = "Visible Title"
    assert @post2.title = "Invisible Title"
  end

  test "published_on should be present" do
    assert @post1.published_on = "2025-01-01"
    assert @post2.published_on = "2025-01-01"
  end

  test "visible is true" do
    assert @post1.visible == true
  end

  test "not visible is false" do
    puts @post2.visible
    assert @post2.visible == false
  end

  test "reading_time returns 1 min for short content" do
    @post1.body = "This is a short post."
    assert_equal "1 min read", @post1.reading_time
  end

  test "reading_time calculates correctly for longer content" do
    # 400 words should be 2 min at 200 wpm
    @post1.body = "word " * 400
    assert_equal "2 min read", @post1.reading_time
  end

  test "reading_time rounds up partial minutes" do
    # 250 words should be 2 min (rounds up from 1.25)
    @post1.body = "word " * 250
    assert_equal "2 min read", @post1.reading_time
  end

  test "content_preview returns plain text excerpt" do
    @post1.body = "<p>Hello <strong>world</strong></p>"
    assert_equal "Hello world", @post1.content_preview
  end

  test "content_preview truncates long text" do
    @post1.body = "a" * 210
    assert_equal ("a" * 200) + "...", @post1.content_preview
  end
end
