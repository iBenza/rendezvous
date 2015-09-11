class Footprint < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  ######################################################################
  # Named scope
  ######################################################################
  scope :today, -> { where(arel_table[:created_at].gt 1.days.ago) }
end
