class Priority < ApplicationRecord
  has_many :tasks, dependent: :restrict_with_error
end
