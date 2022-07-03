class Subcategory < Category

  belongs_to :category, :foreign_key => "parent_id"
  
  has_many :classifieds
    
  named_scope :list, lambda { |catid| {:conditions => ["parent_id = ?", catid]} }
    
  has_permalink :name
  
  def to_param
     permalink
  end  
  
end
