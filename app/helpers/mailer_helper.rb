module MailerHelper
  include ApplicationHelper

  # Merge all link params and tracking params to create a perfect little path for our link.
  # For external links really just means the target_url is a string like 'http://www.linkedin.com' and not something
  # we can call _path() on
  def mailer_link(target_name, target_url, target_params={})
    @tracking_params ||= {}
    query_string = target_params.merge(@tracking_params).to_query
    path = query_string.present? ? "#{target_url}?#{query_string}" : target_url
    link_to(target_name, path)
  end

  def email_image_footer_args
    {
      :from        => 'About eHouseOffers',
      :from_byline => 'We provide real estate guides and connect home sellers with eHouseOffers certified home buyers. You can find us at www.eHouseOffers.com.'
    }
  end
end


