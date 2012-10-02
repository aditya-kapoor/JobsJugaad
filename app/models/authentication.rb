class Authentication < ActiveRecord::Base
  attr_accessible :provider, :uid, :employer_id
  belongs_to :employer
end
