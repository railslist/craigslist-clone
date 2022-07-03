class MainController < ApplicationController

  layout 'main'
  
  def index
    @cities = City.list   
    render :layout=>'main'
  end     
  
  def city      
    @city = City.find_by_permalink(params[:permalink_1])
    @categories = Category.list
    #@cities=City.list    
    @cities = City.find(:all, :limit=> 87)
    @page_title = "#{@city.name.capitalize} Classifieds, free #{@city.name.capitalize} classified ads"        
    
    @page_title = @city.pagetitle
    @page_metakey = @city.metakey
    @page_metadesc = @city.metadesc
    
    session[:cityid]=@city.id
    session[:categoryid]=nil    	
  end      
  
  def category
    @city = City.find_by_permalink(params[:permalink_1])  
    @category = Category.find_by_permalink(params[:permalink_2])                  
    case
    when @category.class.name == "Category"
    
      @classifieds = Classified.paginate(:all,:conditions => {:status=>1, :category_id => @category.id, :city_id=>@city.id}, :page => params[:page], :order => "created_at DESC", :per_page => 10)   
      session[:cityid]=@city.id
      session[:categoryid]=@category.id
      session[:subcategoryid]=nil
      
      @page_title = @city.name + " " + @category.pagetitle
      @page_metakey = @city.name + " " + @category.metakey
      @page_metadesc = @city.name + " " + @category.metadesc
      render :layout => 'category'         
      
    when @category.class.name == "Subcategory"
    
      @classifieds = Classified.paginate(:all,:conditions => {:status=>1, :subcategory_id => @category.id, :city_id=>@city.id}, :page => params[:page], :order => "created_at DESC", :per_page => 10)   
      session[:cityid]=@city.id
      session[:categoryid]=@category.parent_id
      session[:subcategoryid]=@category.id          

      @page_title = @city.name + " " + @category.pagetitle
      @page_metakey = @city.name + " " + @category.metakey
      @page_metadesc = @city.name + " " + @category.metadesc      
      render :layout => 'category' 
    else
      redirect_to :controller=>'main', :action=>'city'
    end
  end    
  
  def activate
    classified=Classified.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && classified && !classified.active?
      classified.activate!
      flash[:success] = "Thank you!. your posting is Active now and can be viewed by our site visitors."           
    when params[:activation_code].blank?
      flash[:info] = "Activation code is missing.  Please follow the link from your email."
    else 
      flash[:error]  = "We cannot find a posting with this activation code - check your email? Or maybe it's already activated."      
    end
    redirect_to('/')
  end  
  
  def mainsearch
    @a = params[:adtype]
    @q = params[:mainquery]
    
    @city = City.find(session[:cityid])    
    @category = Category.find(params[:category][:id])
        
    @classifieds = Classified.paginate(:all,:conditions => ["status = 1 and adtype = ? and city_id = ? and category_id = ? and (title like ? OR description like ?)", @a, session[:cityid], params[:category][:id], "%#{@q}%","%#{@q}%"], :page => params[:page], :order => "created_at DESC", :per_page => 10)                     
    render :layout => 'category'  
  end
  
  def categorysearch
    @a = params[:adtype]
    @q = params[:mainquery]
    
    @city = City.find(session[:cityid])    
    if params[:subcategory][:id].empty?        
      @category = Category.find(session[:categoryid])
      @classifieds = Classified.paginate(:all,:conditions => ["status = 1 and adtype = ? and city_id = ? and category_id = ? and (title like ? OR description like ?)", @a, session[:cityid], session[:categoryid], "%#{@q}%","%#{@q}%"], :page => params[:page], :order => "created_at DESC", :per_page => 10)                            
    else
      @category = Category.find(params[:subcategory][:id])
      @classifieds = Classified.paginate(:all,:conditions => ["status = 1 and adtype = ? and city_id = ? and subcategory_id = ? and (title like ? OR description like ?)", @a, session[:cityid], params[:subcategory][:id], "%#{@q}%","%#{@q}%"], :page => params[:page], :order => "created_at DESC", :per_page => 10)                      
    end
    render :layout => 'category'   
  end
  
  def contactadvertiser
    @classified = Classified.find(params[:id])
    
    if simple_captcha_valid? 
      if (params[:contact][:email].blank? || params[:contact][:msg].blank?)
        flash[:error] = "Error sending your message. Email or Message missing or captcha incorrect. try Again!"
        redirect_to request.referrer
      else
        ContactMailer.deliver_contactadvertiser(@classified, params[:contact])
        flash[:success] = "Your Message to Advertiser sent successfully!. They will get in touch with you soon."
        redirect_to request.referrer
      end
    else
      flash[:error] = "Error sending your message. Email or Message missing or captcha incorrect. try Again!"
      redirect_to request.referrer
    end
  end
  
end
