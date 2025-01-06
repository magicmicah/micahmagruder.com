class TagsController < ApplicationController
  allow_unauthenticated_access(only: [ :show ])

  def show
    @tag = Tag.find_by!(name: params[:id])

    if authenticated?
      @posts = @tag.posts
    else
      # Only show visible posts to unauthenticated users.
      @posts = @tag.posts.visible
    end
  end
end
