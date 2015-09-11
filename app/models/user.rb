require 'faraday'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :validatable

  ######################################################################
  # Associations
  ######################################################################
  has_many :posts, foreign_key: 'author_id'
  has_many :comments, foreign_key: 'author_id'
  has_many :notifications
  has_many :footprints

  has_many :watchings, class_name: 'Watch', foreign_key: 'watcher_id'
  has_many :watching_posts, through: :watchings, source: :watchable, source_type: 'Post'

  ######################################################################
  # scope
  ######################################################################
  scope :post_recently, (lambda do
    User.joins(:posts).group('id').order('posts.updated_at desc')
  end)

  scope :search, (lambda do |query|
    where('name LIKE ? OR nickname LIKE ?', "%#{query}%", "%#{query}%")
  end)

  scope :post_today, -> { joins(:posts).where('posts.updated_at > ?', 1.day.ago) }

  scope :now_viewing, -> { select(:id).joins(:footprints).where('footprints.updated_at > ?', 10.minutes.ago).uniq }

  ######################################################################
  # Validations
  ######################################################################
  validates :name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :nickname, presence: true
  validates :nickname, format: { with: /\A[0-9A-Za-z]+\z/i }
  validates :nickname, uniqueness: true

  ######################################################################
  # instance methods
  ######################################################################

  # push通知を追加
  def push_notification(detail_path, body)
    return if notifications.where(detail_path: detail_path).unread.exists?

    notifications.create(detail_path: detail_path, body: body, is_read: false)
  end

  # record footprint
  def visit_post!(post)
    footprints.create!(post: post)
  end

  def watch!(hash)
    if hash[:post]
      watching_posts << hash[:post] unless watching_posts.include?(hash[:post])
    elsif hash[:tag]
      fail 'Not Implemented.'
    elsif hash[:user]
      fail 'Not Implemented.'
    else
      fail 'No hash argument set.'
    end
  end

  def unwatch!(hash)
    if hash[:post]
      hash[:post].watches.where(watcher: self).destroy_all
    elsif hash[:tag]
      fail 'Not Implemented.'
    elsif hash[:user]
      fail 'Not Implemented.'
    else
      fail 'No hash argument set.'
    end
  end

  # check if user watching post/tag/user
  # TODO: tag/user
  def watching?(hash)
    if hash[:post]
      hash[:post].watches.where(watcher: self).exists?
    elsif hash[:tag]
      fail 'Not Implemented.'
    elsif hash[:user]
      fail 'Not Implemented.'
    else
      fail 'No hash argument set.'
    end
  end

  # def watching_posts
  #   ids = watching_items.where(resource_type: "Post").pluck(:resource_id)
  #   Post.where(id: ids)
  # end
end
