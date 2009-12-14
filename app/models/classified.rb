class Classified < ActiveRecord::Base
 belongs_to :category
 belongs_to :subcategory
 belongs_to :city
 
 validates_presence_of :title
 validates_presence_of :description
 validates_presence_of :email
 validates_format_of   :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
 
 has_attached_file :image, 
  		    :url => "/:attachment/:id_:style.:extension",
  		    :path => ":rails_root/public/:attachment/:id_:style.:extension",
  		    :styles => { :original => "500x500>" }  
  		    
 validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/gif']  		    
 validates_attachment_size :image, :less_than => 175.kilobytes, :message => 'image attachment size should be lessthan 175kb'

 has_permalink :title, :as => :permalink, :param => false
  
 def to_param
   permalink
 end  
   
 apply_simple_captcha :message=>'Values entered did not match image in step 5', :add_to_base => true
 
 def activate!    
   self.status = 1
   save(false)
 end
 
 def active?
   #Ad is inactive if status is zero
   status==1
 end
 
end
