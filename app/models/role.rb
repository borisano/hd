class Role < ApplicationRecord
  ADMIN_ROLE_NAME = "admin"
  has_many :users, dependent: :restrict_with_error
end
