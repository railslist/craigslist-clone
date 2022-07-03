class Category < ActiveRecord::Base

  has_many    :subcategories, :foreign_key => "parent_id"
  has_many :classifieds
  
  named_scope :list, :conditions => {:parent_id => '0'}, :order => "pos asc"    
      
  has_permalink :name
  
  def to_param
     permalink
  end  
  
end
