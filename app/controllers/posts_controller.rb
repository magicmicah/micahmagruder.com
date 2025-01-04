class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  allow_unauthenticated_access(only: [ :index, :show ])

  # GET /posts or /posts.json
  def index
    @posts = if authenticated?
      if params[:query].present?
        @search_query = params[:query] # Store the query for display purposes
        # get the total results
        @search_results = Post.visible.search(params[:query]).count
        @posts = Post.page(params[:page]).per(Kaminari.config.default_per_page).search(params[:query]).order(published_on: :desc)
      else
        @posts = Post.page(params[:page]).per(Kaminari.config.default_per_page).order(published_on: :desc)
      end
    else
      if params[:query].present?
        @search_query = params[:query] # Store the query for display purposes
        # get the total results
        @search_results = Post.visible.search(params[:query]).count
        @posts = Post.visible.page(params[:page]).per(Kaminari.config.default_per_page).search(params[:query]).order(published_on: :desc)
      else
        @posts = Post.visible.page(params[:page]).per(Kaminari.config.default_per_page).order(published_on: :desc)
      end
    end
  end

  # GET /posts/1 or /posts/1.json
  def show
    @posts = if authenticated?
      Post.all
    else
      Post.visible
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        @post.add_tags(params[:post][:tag_names].split(",")) if params[:post][:tag_names].present?
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        @post.add_tags(params[:post][:tag_names].split(",")) if params[:post][:tag_names].present?
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.expect(post: [ :title, :body, :visible, :published_on, :tag_names ])
    end
end
