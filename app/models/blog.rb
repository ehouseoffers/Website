class Blog < ActiveRecord::Base
  belongs_to :user

  # Don't change the order. You can add on, but do not change the order without grepping the code for places
  # where we pluck out values assuming they will be consistent (see translate_route_to_context below)
  VALID_CONTEXTS = %w[trends reasons guides]
  
  # TODO -- younker [2010-11-09 10:51]
  # move photo styles, size and types into config
  has_attached_file :photo, :styles => { :small => '130x130>', :medium => "200x200>", :large => '300x300>' },
                    :url  => "/assets/blog/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/blog/:id/:style/:basename.:extension"
  
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 500.kilobytes 
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  validates_presence_of :user_id, :content, :title
  validates :title_for_url, :uniqueness => true

  validate :context do
    errors.add(:context, 'invalid type') unless valid_context?
  end

  before_validation :title do
    if (self.new_record? && self.title_for_url.blank?) || self.title_for_url.blank?
      write_attribute(:title_for_url, self.title.make_url_friendly)
    end
  end

  # Do NOT update unless it is a new record. Once it is saved, we do not modify so that if any search engines have
  # indexed this guide using the url friendly title string, we do not hose ourself by changing the path to it
  def title_for_url=(string)
    if self.new_record?
      write_attribute(:title_for_url, string)
    end
  end
  
  def valid_context?
    VALID_CONTEXTS.include?(self.context)
  end
  
  # -- Should be called by blogs_controller.setup_for_blog_context --
  # We are changing the route names for the entire site, including our blog types/contexts. for example, 'guides' is
  # now 'real-estate-guides'. So this will translate the route name to the context we have been working with and expect.
  # https://ehouseoffers.fogbugz.com/default.asp?8
  def self.translate_route_to_context(route)
    case route
    when 'real-estate-trends' then VALID_CONTEXTS[0]
    when 'sell-my-house'      then VALID_CONTEXTS[1]
    when 'how-to-sell-house'  then VALID_CONTEXTS[2]
    end
  end

  # used for will_paginate hacking (BlogPaginationListLinkRenderer)
  def self.translate_context_to_route(context)
    case context
    when VALID_CONTEXTS[0] then 'real-estate-trends'
    when VALID_CONTEXTS[1] then 'sell-my-house'
    when VALID_CONTEXTS[2] then 'how-to-sell-house'
    end
  end
end
