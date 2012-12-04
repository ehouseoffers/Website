require 'net/http'

class FastHomeOffer
  attr_accessor :seller_listing, :post_args, :resp, :resp_data

  POST_URL = 'http://partner.fasthomeoffer.com/services/formpost.asp'

  REQUIRED_KEYS = %w[:frmUSERNAME :frmPASSWORD :frmFNAME :frmLNAME :frmEMAIL :frmPHONE1
    :frmADDRESS :frmCITY :frmSTATE :frmPROP_TYPE :frmIS_LISTED]

  def initialize(seller_listing)
    @seller_listing = seller_listing
    @post_args = transform_seller_listing_data
  end

  # We have to have post_args? for all REQUIRED_KEYS in order for this to be sendable
  def sendable?
    REQUIRED_KEYS.all?{|k| post_arg?(k) }
  end

  # Do we have post data (transformed seller listing data) for this key?
  def post_arg?(k)
    post_args.fetch(k, false)
  end

  # POST this seller listing to fast homes
  # From their documentation:
  # The response to this form post will be either 1:{leadid} or 0:{error string}.
  def post_to_fast_home!
    @resp, @resp_data = Net::HTTP.post_form(POST_URL, post_args)
  end

  def post_success?
    # TODO -- younker [2012-12-04 11:13] -- Come up with something better than this
    @resp.present? && @resp.first
  end

  private

    # From their documentation: For testing, only use zip code ‘99999’ to prevent
    # leads from being put into production environment.
    def double_check_seller_listing_zip
      Rails.env.production? ? seller_listing.address.zip : 99999
    end
  
    # Turn our seller listing data into a structure the fast home people expect.
    # * -- Data we do not collect (we return nil)
    # NOTE: 
    def transform_seller_listing_data
      {
        # Required Data
        frmUSERNAME: KEYS['fast_home_offers']['username'], # Our Username
        frmPASSWORD: KEYS['fast_home_offers']['password'], # Our Password
        frmFNAME: seller_listing.user.first_name,
        frmLNAME: seller_listing.user.last_name,
        frmEMAIL: seller_listing.user.email,
        frmPHONE1: seller_listing.phone_number.number,
        frmADDRESS: seller_listing.address.address,
        frmCITY: seller_listing.address.city,
        frmSTATE: seller_listing.address.state,
        frmZIP: double_check_seller_listing_zip,
        frmPROP_TYPE: nil, # * Property Type: single family, mobile home, etc
        frmIS_LISTED: nil, # * Listed with Real Estate Agent? (Text [Yes|No])

        # Optional
        frmPHONE2: nil,            # * Secondary Phone
        frmSQFT: nil,              # * Property Square Feet (Integer)
        frmNUM_BEDROOMS: nil,      # * Number of Bedrooms (Integer)
        frmNUM_BATHROOMS: nil,     # * Number of Bathrooms (Double: 1, 2.5, 3)
        frmGARAGE: nil,            # * Number of Garage Bays (Integer)
        frmPOOL: nil,              # * Pool? (Text [Yes|No])
        frmCAN_CONTACT_OWNER: nil, # * Text (Yes|No)
        frmIS_OCCUPIED: nil,       # * Is the property presently occupied? (Text [Yes|No])
        frmMARKET_VALUE: seller_listing.estimated_value,
        frmASKING_PRICE: seller_listing.asking_price,
        frmREPAIRS: nil,           # * Repairs Needed? (Memo)
        frmSELLING_REASON: seller_listing.selling_reason,
        frmBALANCE: nil,           # * Balance on all loans (Currency)
        frmMONTHLY_PAYMENT: nil,   # * total monthly payment (Currency)
        frmBEHIND: nil,            # * Are they behind in their payments? (Text [Yes|No])
        frmARREARS: nil,           # * Total amount they are behind (Currency)
        frmSOURCE: nil,            # * How did they find you? (Text(Google, billboard, etc))
        frmNOTES: nil,             # * Comments from home owner (memo)
        frmMIN_ASK_PRICE: nil,     # * Price for Cash (Currency)
        frmID: selling_reason.id
      }
    end
end