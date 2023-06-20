class Goal < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  include PgSearch::Model

    pg_search_scope :search_by_name_category_amount_frequency,
     against: [:name, :category, :amount],
    using: {
    tsearch: { prefix: true }
   }


end
