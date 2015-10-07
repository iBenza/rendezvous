class PostTag < ActiveRecord::Base
  belongs_to :post
  belongs_to :tag

  after_create :increment_posts_count
  after_update :update_posts_count
  after_destroy :decrement_posts_count

  private

  def increment_posts_count
    Tag.increment_counter(:posts_count, tag_id)
  end

  def update_posts_count
    Tag.decrement_counter(:posts_count, previous_changes[:tag_id].first)
    Tag.increment_counter(:posts_count, tag_id)
  end

  def decrement_posts_count
    Tag.decrement_counter(:posts_count, tag_id)
  end
end
