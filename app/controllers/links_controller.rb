class LinksController < ApplicationController
  include ApiAuthentication

  skip_forgery_protection if: :api_request?
  before_action :set_link, only: %i[ show edit update destroy ]
  skip_before_action :require_authentication, only: [ :index, :show, :create ]
  before_action :authenticate_request, only: [ :create ]

  # GET /links or /links.json
  def index
    @links = if params[:query].present?
      @search_query = params[:query]
      @search_results = Link.search(params[:query]).count
      Link.search(params[:query]).recent.page(params[:page]).per(20)
    else
      Link.recent.page(params[:page]).per(20)
    end
  end

  # GET /links/1 or /links/1.json
  def show
  end

  # GET /links/new
  def new
    @link = Link.new
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links or /links.json
  def create
    @link = Link.new(link_params)

    respond_to do |format|
      if @link.save
        format.html { redirect_to links_path, notice: "Link was successfully created." }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1 or /links/1.json
  def update
    # Clear non-domain tags, then let callbacks re-add from tag_names
    if params.dig(:link, :tag_names).present?
      domain_tag = @link.tags.find_by(name: @link.domain&.downcase)
      @link.tags.clear
      @link.tags << domain_tag if domain_tag
    end

    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to links_path, notice: "Link was successfully updated." }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1 or /links/1.json
  def destroy
    @link.destroy!

    respond_to do |format|
      format.html { redirect_to links_path, status: :see_other, notice: "Link was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def authenticate_request
    if api_request?
      authenticate_api_token!
    else
      require_authentication
    end
  end

  def set_link
    @link = Link.find(params[:id])
  end

  def link_params
    params.expect(link: [ :title, :url, :comment, :bookmarked_at, :tag_names ])
  end
end
