class CategoriesController < ApplicationController
  before_filter :authorize
  layout 'main'
 
  def index
    @categories = Category.list
  end

  def show
    @category = Category.find_by_permalink(params[:id])
  end

  def new
    @category = Category.new
  end


  def edit
    @category = Category.find_by_permalink(params[:id])
  end

  def create
    @category = Category.new(params[:category])
    @category.type="Category"

    if @category.save
      flash[:notice] = 'Category was successfully created.'
      redirect_to(categories_path)
    else
      render :action => "new"
    end
  end

  def update
    @category = Category.find_by_permalink(params[:id])

    if @category.update_attributes(params[:category])
      flash[:notice] = 'Category was successfully updated.'
      redirect_to(categories_path)
    else
      render :action => "edit"
    end
  end


  def destroy
    @category = Category.find_by_permalink(params[:id])
    @category.destroy

    redirect_to(categories_url)
  end
end
