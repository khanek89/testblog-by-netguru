class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable

  field :body, type: String
  field :title, type: String
  field :archived, type: Boolean, default: false

  validates_presence_of :body, :title

  belongs_to :user
  has_many :comments

  default_scope ->{ ne(archived: true) }

  def archive!
    update_attribute :archived, true
  end

  def hotness
    hotness_score = 0
    created_at = self.created_at

    if created_at > 24.hours.ago
      hotness_score = 3
    elsif created_at.between?(72.hours.ago, 24.hours.ago)
      hotness_score = 2
    elsif created_at.between?(7.days.ago, 3.days.ago)
      hotness_score = 1
    elsif created_at < 7.days.ago
      hotness_score = 0
    end
    hotness_score += 1 if self.comments.size >= 3
    hotness_score
  end

end
