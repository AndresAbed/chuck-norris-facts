class Search < ApplicationRecord
  has_many :results, dependent: :destroy
end
