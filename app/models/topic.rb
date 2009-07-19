class Topic < ActiveRecord::Base  
    
  belongs_to :user
  has_many :posts, :dependent => :delete_all do
    def per_page(params, per_page = 10)
      paginate :per_page => per_page, :page => params[:page]
    end    
  end  
    
  validates_presence_of :title, :content
    
  def switch_state
    self.update_attribute(:opened, !self.opened?)    
  end
  
  def self.per_page( params, per_page = 10)
    if params[:search]      
      Topic.paginate(:per_page => per_page, :page => params[:page], :order => 'created_at DESC', :conditions => ['title LIKE ?', "%#{params[:search]}%"])  
     else
      Topic.paginate(:per_page => per_page, :page => params[:page], :order => 'created_at DESC')         
     end   
  end
      
end
