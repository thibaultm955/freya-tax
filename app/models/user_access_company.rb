class UserAccessCompany < ApplicationRecord
  belongs_to :company
  belongs_to :user
  belongs_to :access
end
