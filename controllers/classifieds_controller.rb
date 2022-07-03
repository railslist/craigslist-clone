class ClassifiedsController < ApplicationController
  before_filter :authorize, :only=>[:index, :delete_multiple, :admin_search]
  
  def index
    @classifieds = Classified.paginate(:all, :page => params[:page], :order => "created_at DESC", :per_page => 20)   
    render :layout => 'main'
  end
  
  def show            
    @classified = Classified.find_by_permalink(params[:permalink_3])
    if !@classified.active?
      redirect_to('/') 
    else
      @page_title = "#{@classified.title}, #{@classified.location} #{@classified.city.name}"
      render :layout=>'classifieds'
    end
  end 

  def new
    @classified = Classified.new
    #render :layout => 'classifieds'
  end
  
  def create
    params[:classified][:title] = CGI.escapeHTML(params[:classified][:title])    
    params[:classified][:location] = CGI.escapeHTML(params[:classified][:location])    

    @classified = Classified.new(params[:classified])
    @classified.activation_code = ActiveSupport::SecureRandom.hex(20)
    @classified.category_id = @classified.subcategory.parent_id
    if @classified.save_with_captcha
      ContactMailer.deliver_adactivationlink(@classified)
      flash[:success]="Thankyou!. We have sent you an Activation Link. Check your email and activate your posting."  
      redirect_to('/')
    else
      render :action=>'new'
    end
  end  
  
  def edit  
    if admin?
      @classified=Classified.find_by_permalink(params[:id])
    else
      @classified=Classified.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
      case
      when (!params[:activation_code].blank?) && @classified
        render :layout => 'classifieds'
      when params[:activation_code].blank?
        flash[:info] = "Activation code is missing.  Please follow the link from your email."     
        redirect_to('/')
      else 
        flash[:error]  = "We cannot find a Classified Ad with this activation code - check your email?"
        redirect_to('/')
      end
    end
  end  
  
  def update
    params[:classified][:title] = CGI.escapeHTML(params[:classified][:title])    
    params[:classified][:location] = CGI.escapeHTML(params[:classified][:location])      
  
    @classified=Classified.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?   
     
    t = Subcategory.find(params[:classified][:subcategory_id])
    params[:classified][:category_id] = t.parent_id
    
    if @classified.update_attributes(params[:classified])
      flash[:success]="Changes to Classified Ad have been successfully updated!."
      if admin?
        redirect_to (classifieds_path)
      else
        redirect_to('/')
      end
    else        
      render :action => "edit"
    end        
  end  
  
  def destroy
    if admin?
      @classified=Classified.find_by_permalink(params[:id]).destroy
      redirect_to classifieds_path 
    else
      @classified=Classified.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    
      case
      when (!params[:activation_code].blank?) && @classified
        Classified.find_by_activation_code(params[:activation_code]).destroy
        flash[:success]="Your Classified Ad has been successfully Removed!."
      when params[:activation_code].blank?
        flash[:info] = "Activation code is missing.  Please follow the link from your email."      
      else 
        flash[:error]  = "We cannot find a Classified Ad with this activation code - check your email?"
      end      
      redirect_to('/')          
    end            
  end
  
  def delete_multiple
    @checked = Classified.find(params[:remove][:id]) 
    unless @checked.empty? || @checked.blank? || @checked.nil?       
       @checked.each { |r| r.destroy if admin? }       
    end    
    flash[:success] = "checked ads have been successfully deleted!." 
    redirect_to(classifieds_path)
  end
  
  def adminsearch    
    if params[:subcategory][:id].blank?
      @classifieds = Classified.paginate(:all, :conditions=>["#{params[:fid]}  #{params[:fop]}  ?", params[:query]], :page => params[:page], :order => "created_at DESC", :per_page => 20)
    else
      if !params[:query].blank?
        @classifieds = Classified.paginate(:all, :conditions=>["#{params[:fid]}  #{params[:fop]}  ? AND subcategory_id = ?", params[:query], params[:subcategory][:id]], :page => params[:page], :order => "created_at DESC", :per_page => 20)
      else        
        @classifieds = Classified.paginate(:all, :conditions=>["subcategory_id = ?", params[:subcategory][:id]], :page => params[:page], :order => "created_at DESC", :per_page => 20)
      end        
    end
    render :action => 'index', :layout=>'main'
  end
end
