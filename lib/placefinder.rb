# Yahoo! Place Finder Geolocator 
# http://developer.yahoo.com/geo/placefinder/guide/requests.html

##
## This is a quick and dirty way to call yahoo placefinder and get what we need: a city, state and zip for a zip code.
## We could do alot more with this, but I figured we can develop as needed
## 
class Placefinder
  attr_accessor :query_base, :query_string, :response, :error, :error_message, :city, :state, :zip

  def initialize(query_params={})
    self.query_base = {
      :appid   => KEYS['placefinder']['app_id'],
      :flags   => 'J',
      :country => 'USA'
    }
    self.query_string = self.query_base.merge(query_params).to_query
  end

  def url
    URI.parse([KEYS['placefinder']['base'], self.query_string].join('?'))
  end

  def call_api
    begin
      raw = Net::HTTP.get_response(self.url).body
      self.response = JSON.parse(raw)
      self.validate # should raise if problem is found
      self.error = false
      true # success
    rescue Exception => e
      Rails.logger.warn("** Placefinder Warning! #{e}")
      self.error = true
      self.error_message ||= 'Internal Error. Please try again later.'
      false # success
    end
  end

  protected
  def validate
    if self.response['ResultSet']['Error'].eql?(1)
      self.error_message = self.response['ResultSet']['ErrorMessage']
      raise self.error_message

    elsif self.response['ResultSet']['Found'] == 0
      self.error_message = "This zip code did not match any know zip code inside the United States."
      raise self.error_message

    elsif !self.response['ResultSet']['Results'].first['countrycode'].eql?('US')
      self.error_message = "The zip code must be a valid zip code for property inside the United States."
      raise self.error_message
      
    elsif self.response['ResultSet']['Found'] > 1
      self.error = false
      Rails.logger.warn("We got back more than 1 result in our ResultSet. Picking the first one and hoping for the best. ResultSet = #{self.response['ResultSet'].inspect}")
      self.parse_results(self.response['ResultSet']['Results'].first)

    elsif self.response['ResultSet']['Found'] == 1
      self.error = false
      self.parse_results(self.response['ResultSet']['Results'].first)

    else
      self.error_message "Internal Error. Please try again later"
      raise self.error_message

    end
  end
  
  # Response/Error Codes (http://developer.yahoo.com/geo/placefinder/guide/responses.html#error-codes)
  #   0:    No error
  #   1:    Feature not supported
  #   100:  No input parameters
  #   102:  Address data not recognized as valid UTF-8
  #   103:  Insufficient address data
  #   104:  Unknown language
  #   105:  No country detected
  #   106:  Country not supported
  #   10NN: Internal problem detected


  # For now, we are only concerned with city, state and zip
  def parse_results(data)
    self.city = data['city']
    self.state = data['statecode']
    self.zip = data['postal']

    # API Docs: 'Second line of address (City State Zip in the US). Returned if C flag is not set.'
    # So if we are missing any of this, try to get it from line2. {'line2' => "Yakima, WA  98908"}
    if self.city.blank? || self.state.blank? || self.zip.blank?
      city, state_zip = data['line2'].split(',')
      self.city = city if self.city.blank? && city.present?
      
      state, zip = state_zip.strip.gsub(/\s+/,' ').split(' ')
      self.state = state if self.state.blank? && state.present?
      self.zip = zip if self.zip.blank? && zip.present?
    end
  end
end
