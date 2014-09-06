
class Book < ActiveRecord::Base
  validates_presence_of :isbn

  def search_amazon
    req = Vacuum.new
    req.configure(
      aws_access_key_id:     ENV["AWS_ACCESS_KEY_ID"],
      aws_secret_access_key: ENV["SECRET_AWS_ACCESS_KEY"],
      associate_tag: ENV["ASSOCIATE_TAG"]
      )
    res = req.item_lookup(query: amazon_search_params)
    res = res.to_h
    res["ItemLookupResponse"]["Items"]["Item"]
  end

  def get_book_attributes
    req = Vacuum.new
    req.configure(
      aws_access_key_id:     ENV["AWS_ACCESS_KEY_ID"],
      aws_secret_access_key: ENV["SECRET_AWS_ACCESS_KEY"],
      associate_tag: ENV["ASSOCIATE_TAG"]
      )
    res = req.item_lookup(query: search_params)
    res = res.to_h
    item = res["ItemLookupResponse"]["Items"]["Item"]
    item = item.first if item.is_a?(Array)
    item["ItemAttributes"]
  end

  def amazon_search_params
    {
      'IdType' => 'ISBN',
      'ResponseGroup' => 'Offers',
      'ItemId' => self.isbn,
      'SearchIndex' => 'All'
    }
  end

  def search_params
    {
      'IdType' => 'ISBN',
      'ResponseGroup' => 'ItemAttributes',
      'ItemId' => self.isbn,
      'SearchIndex' => 'All'
    }
  end

  # def canonical_request
  #   canonical_uri = '/'
  #   canonical_querystring = ""
  #   canonical_headers = 'host:' + host + "\n" + 'x-amz-date:' + amzdate + "\n"
  #   signed_headers = 'host;x-amz-date'
  #   #payload_hash = hashlib.sha256('').hexdigest()
  #   payload_hash = Digest::SHA256.hexdigest ''
  #   'Get' + "\n" + canonical_uri + "\n" + canonical_querystring + "\n" + canonical_headers + "\n" + signed_headers + "\n" + payload_hash
  # end
  #
  # def string_to_sign
  #   algorithm = 'AWS4-HMAC-SHA256' + "\n"
  #   request_date = amzdate + "\n"
  #   credential_scope = date_stamp + '/' + region_name + '/' + service_name + '/' + 'aws4_request' + "\n"
  #   hashed_canonical_request = Digest::SHA256.hexdigest canonical_request
  #   algorithm + request_date + credential_scope + hashed_canonical_request
  # end
  #
  # def get_signature_key key, date_stamp, region_name, service_name
  #   date    = OpenSSL::HMAC.digest('sha256', "AWS4" + key, date_stamp)
  #   region  = OpenSSL::HMAC.digest('sha256', date, region_name)
  #   service = OpenSSL::HMAC.digest('sha256', region, service_name)
  #   signing = OpenSSL::HMAC.digest('sha256', service, "aws4_request")
  #   signing
  # end
  #
  # def derived_signing_key
  #   get_signature_key(ENV["SECRET_AWS_ACCESS_KEY"], date_stamp, region_name, service_name)
  # end
  #
  # def signature
  #   OpenSSL::HMAC.new(derived_signing_key, (string_to_sign).encoding(Encoding::UTF_8), Digest::SHA256).hexdigest()
  # end
  #
  # private
  #
  #   def host
  #     'iam.amazonaws.com'
  #   end
  #   def region_name
  #     'us-east-1'
  #   end
  #   def date_stamp
  #     Time.now.strftime("%Y%m%d")
  #   end
  #   def amzdate
  #     Time.now.strftime('%Y%m%dT%H%M%SZ')
  #   end
  #   def service_name
  #     "iam"
  #   end
  #   #may delete both endpoint and request_parameters
  #   def endpoint
  #     'https://ec2.amazonaws.com'
  #   end
  #   def request_parameters
  #     'Action=DescribeRegions&Version=2013-10-15'
  #   end

end
