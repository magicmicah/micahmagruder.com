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

  test "preview should be present" do
    assert @post1.preview = "Preview"
    assert @post2.preview = "Preview"
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
end
