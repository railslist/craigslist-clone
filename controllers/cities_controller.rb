class CitiesController < ApplicationController  
  
  before_filter :authorize
  layout 'main'
  
  def index
    @cities = City.list   
    render :layout=>'main'
  end       

  def new
    @city = City.new
  end
  
  def create
    @city = City.new(params[:city])
    if @city.save
      flash[:notice] = 'City was successfully added.'
      redirect_to(cities_path)
    else
      render :action => "new"
    end
  end
  
  def edit
    @city = City.find_by_permalink(params[:id])
  end
    
  def update
    @city = City.find_by_permalink(params[:id])
    if @city.update_attributes(params[:city])
      flash[:notice] = 'City was successfully updated.'
      redirect_to(cities_path)
    else
      render :action => "edit"
    end
  end  
  
  def destroy
    @city = City.find_by_permalink(params[:id])
    @city.destroy
    redirect_to(cities_path)
  end  
    
end
