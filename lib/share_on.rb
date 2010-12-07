# TODO -- younker [2010-12-07 13:14]
# Add Stumble upon? <script src="http://www.stumbleupon.com/hostedbadge.php?s=3"></script>

class ShareOn
  attr_accessor :social_site, :resource, :base, :api_args, :query_string, :url

  # Should be called only as super
  def initialize
    self.query_string = self.api_args.to_query
    self.url = [self.base, self.query_string].join('?')

    raise "Resource (#{self.resource}) must be a fully qualified path" unless self.valid_path?(self.resource)
    raise "API url must be a fully qualified path" unless self.valid_path?(self.url)
  end


  # overly simplified error checking, mostly so I don't forget to do provide the basics
  def valid_path?(path)
    path.to_s.match(/^http(s)?:\/\//).present?
  end
end

# http://dev.twitter.com/pages/tweet_button
class ShareOn::Twitter < ShareOn
  def initialize(args={})
    self.social_site = 'twitter'
    self.base = KEYS['twitter']['base']
    self.resource = args[:resource] || raise('No resource passed to constructor') # URL of the page to share

    self.api_args = {
      :via  => KEYS['twitter']['username'],
      :text => "#{APP_CONFIG['site_name']}: #{args[:title]}",
      :url  => self.resource,
    }
    super()
  end
end


# http://developer.linkedin.com/docs/DOC-1075
class ShareOn::LinkedIn < ShareOn
  def initialize(args={})
    self.social_site = 'linkedin'
    self.base = KEYS['linkedin']['base']
    self.resource = args[:resource] || raise('No resource passed to constructor') # URL of the page to share


    # NOTE!
    # any resource not from http://28dev.com seems to blow up. WTF?

    # http://www.linkedin.com/shareArticle?mini=true&url=#{url}&title=#{title}&summary=#{summary}&source=#{source}
    self.api_args = {
      :mini    => true,
      :url     => self.resource,
      :title   => args[:title],
      :summary => args[:summary],
      :source  => KEYS['linkedin']['source'],
    }
    super()
  end
end

class ShareOn::Facebook < ShareOn
  BASE = 'http://www.facebook.com/plugins/like.php'

  def initialize(args={})
    self.social_site = 'facebook'
    self.base = BASE
    self.resource = args[:resource] || raise('No resource passed to constructor') # URL of the page to share
    self.api_args = {}
    super()
  end
  
  # There is no api url for facebook, we use the js api
  def url
    self.resource
  end
end



