class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.ransackable_attributes(auth_object = nil)
  [ "body", "created_at", "post_id", "user_id" ]
  end
end
