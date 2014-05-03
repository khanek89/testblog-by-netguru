class Vote
  include Mongoid::Document
  include Mongoid::Timestamps

  field :value, type: Integer, default: nil

  belongs_to :user
  belongs_to :comment

  validates :user_id, :uniqueness => { :scope => :comment_id }

  after_save do
    self.comment.abusive! if self.comment.votes.where(value: -1).count >= 3
  end

end
