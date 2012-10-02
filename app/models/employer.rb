class Employer < ActiveRecord::Base
  attr_accessible :name, :email, :website, :description, 
                  :password, :password_confirmation, :photo,
                  :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at,
                  :auth_token, :activated, :password_reset_token

  has_many :authentications

  has_many :jobs, :dependent => :destroy
  has_secure_password

  validates :name, :presence  => true

  validates :password, :presence => true, :if => :password
  validates :password, :length => { :minimum => 6 }, :unless => proc { |user| user.password.blank? }
  validates :password_confirmation, :presence => true, :if => :password 
  
  validates :email, :presence => true, :uniqueness => true
  validates_format_of :email,
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    :message => "Doesn't Looks the correct email ID", :unless => proc { |user| user.email.blank? }

  validates :website, :presence => true
  validates_format_of :website, 
    :with    => /^(https?:\/\/)?((([A-z]+)\.)*)([A-z]+\.[A-z]{2,4})$/,
    :message => "Doesn't looks like correct Website URL" 

  has_attached_file :photo, :styles => { :small => "175x175>" }, 
    :default_url => '/assets/default-photo/default.gif'

  validates_attachment_size :photo, :less_than => 6.megabytes, :message => "Must be less than 6 MB"
  validates :photo_file_name, :allow_blank => true, :format => {
    :with => %r{[.](jpg|jpeg|png|ico|gif)$}i, 
    :message => "Invalid Photo Format: Allowed Formats Are Only in jpeg, jpg, png, ico and gif"
  }

  after_create :send_authentication_email
  
  def send_authentication_email
    auth_token = BCrypt::Password.create("Tutu")
    self.update_attributes(:auth_token => auth_token, :activated => false)
    Notifier.activate_user(self, auth_token).deliver
  end

  serialize :auth_hash, Hash

  def twitter(auth_hash)
    @tw_user ||= prepare_access_token(user_attributes(auth_hash)[:token], user_attributes(auth_hash)[:secret])
  end

  def user_attributes(auth_hash)
    @user_attributes ||= extract_user_attributes(auth_hash)
  end

  def publish(text, auth_hash)
    case auth_hash['provider']
    when 'twitter'
      then twitter(auth_hash).request(:post, "http://api.twitter.com/1/statuses/update.json", :status => text)
    end
  end

  protected

  def extract_user_attributes(hash)
    user_credentials = hash['credentials'] || {}
    user_info = hash['user_info'] || {}
    user_hash = hash['extra'] ? (hash['extra']['user_hash'] || {}) : {}
    
    { 
      :token => user_credentials['token'],
      :secret => user_credentials['secret'],
      :name => user_info['name'], 
      :email => (user_info['email'] || user_hash['email']),
      :nickname => user_info['nickname'],
      :last_name => user_info['last_name'],
      :first_name => user_info['first_name'],
      :link => (user_info['link'] || user_hash['link']),
      :photo_url => (user_info['image'] || user_hash['image']),
      :locale => (user_info['locale'] || user_hash['locale']),
      :description => (user_info['description'] || user_hash['description'])
    }
  end

  def prepare_access_token(oauth_token, oauth_token_secret)
    consumer = OAuth::Consumer.new('eZ17eRpN1In39HuCfM5WA', 'SfXvytpQro7PctvJhFAEbxjiY5uTT6ICqc52gzwQxMc', 
      { :site => "http://api.twitter.com" })
    # now create the access token object from passed values
    token_hash = { :oauth_token => oauth_token, :oauth_token_secret => oauth_token_secret }
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
    return access_token
  end

end
