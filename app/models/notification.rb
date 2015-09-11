class Notification < ActiveRecord::Base
  belongs_to :user

  ######################################################################
  # Named scope
  ######################################################################

  scope :unread, (lambda do
    where(is_read: false)
  end)

  scope :recent, (lambda do
    where(arel_table[:created_at].gt 7.day.ago)
  end)

  ######################################################################
  # Instance method
  ######################################################################

  # 既読にする
  def set_read!
    update!(is_read: true, read_at: Time.now)
  end
end
