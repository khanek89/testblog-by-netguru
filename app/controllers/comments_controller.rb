class CommentsController < ApplicationController
  before_filter :authenticate_user!
  expose_decorated(:comments) { Comment.all }
  expose_decorated(:comment, attributes: :comment_params)

  def index
  end

  def new
  end

  def edit
  end

  def update
    if comment.save
      render action: :index
    else
      render :new
    end
  end

  def destroy
    comment.destroy if current_user.owner? comment
    render action: :index
  end

  def show
  end

  def create
    post = Post.find(params[:post_id])
    comment = post.comments.new(params[:comment])
    comment.user = current_user
    if comment.save
      redirect_to action: :show, id: post, controller: :posts
    else
      render :new
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end

end
