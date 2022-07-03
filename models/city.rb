class City < ActiveRecord::Base   
  has_many :classifieds 
  
  named_scope :list, :select => 'id, name, permalink', :order => "name ASC"
     
  has_permalink :name  

  def to_param
     permalink
  end     

end
