require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post1 = posts(:one)
  end

  test "should get index" do
    get posts_url
    assert_response :success
  end

  test "unauthenticed should not get new" do
    get new_post_url
    assert_response :redirect
  end

  # test "should create post" do
  #   assert_difference("Post.count") do
  #     post posts_url, params: { post: { rich_body: @post1.body, preview: @post1.preview, published_on: @post1.published_on, title: @post1.title, visible: @post1.visible } }
  #   end

  #   assert_redirected_to post_url(Post.last)
  # end

  test "unauthenticated should show post" do
    get post_url(@post1)
    assert_response :success
  end

  test "unauthenticated should not get edit" do
    get edit_post_url(@post1)
    assert_response :redirect
  end

  # test "should update post" do
  #   patch post_url(@post1), params: { post: { body: @post1.body, published_on: @post1.published_on, title: @post1.title, visible: @post1.visible } }
  #   assert_redirected_to post_url(@post1)
  # end

  test "unauthenticated should not destroy post" do
    assert_difference("Post.count", 0) do
      delete post_url(@post1)
    end
  end
end
