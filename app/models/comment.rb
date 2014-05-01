class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :body, type: String
  field :abusive, type: Boolean, default: false

  validates_presence_of :body

  belongs_to :user
  belongs_to :post

  def abusive!
    update_attribute :abusive, true
  end
end
