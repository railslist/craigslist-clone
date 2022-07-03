class UsersController < ApplicationController

  def show
    redirect_to categories_path if admin?
  end
  
  def create
    session[:password] = params[:password]
    flash[:success] = "Administrator login successful!" if admin?
    redirect_to categories_path
  end
  
  def destroy    
    session[:password]=nil
    reset_session
    cookies.delete :password
    flash[:notice]="successfully logged out!"
    redirect_to :controller=>'main'    
  end
  
end
