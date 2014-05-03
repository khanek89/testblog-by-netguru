class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :body, type: String
  field :abusive, type: Boolean, default: false

  validates_presence_of :body

  belongs_to :user
  belongs_to :post
  has_many :votes

  def not_abusive!
    update_attribute :abusive, false
  end

  def abusive!
    update_attribute :abusive, true
  end

  def votes_up
    self.votes.where(value: 1).size
  end

  def votes_down
    self.votes.where(value: -1).size
  end

  def votedby? user
    Vote.where(user_id: user.id, comment_id: self.id).exists?
  end

end
