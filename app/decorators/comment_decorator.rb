class CommentDecorator < Draper::Decorator
  decorates :comment
  delegate_all

  def truncated_body
    h.raw h.truncate(body, length: 200, omission: "...")
  end
end
