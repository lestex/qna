class Vote < ApplicationRecord
  include HasUser
  belongs_to :votable, polymorphic: true, optional: true
end
