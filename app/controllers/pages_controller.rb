class PagesController < ApplicationController
  before_action :set_page, only: %i[show edit update destroy]
  allow_unauthenticated_access(only: [:show])

  # GET /pages
  def index
    @pages = Page.order(:title)
  end

  # GET /:slug (public view)
  def show
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/:id/edit
  def edit
  end

  # POST /pages
  def create
    @page = Page.new(page_params)

    if @page.save
      redirect_to page_path(@page), notice: "Page was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pages/:id
  def update
    if @page.update(page_params)
      redirect_to page_path(@page), notice: "Page was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /pages/:id
  def destroy
    @page.destroy!
    redirect_to pages_path, status: :see_other, notice: "Page was successfully destroyed."
  end

  private

  def set_page
    @page = Page.find_by!(slug: params[:slug]) if params[:slug]
    @page ||= Page.find(params[:id])
  end

  def page_params
    params.require(:page).permit(:title, :slug, :content, :show_in_nav)
  end
end
