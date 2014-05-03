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

  def vote_up
    comment = Comment.find(params[:id])
    vote = Vote.new comment: comment, user: current_user.id, value: 1
    if not vote.save
      flash[:notice] = "Nie można votować dwa razy drogi użytkowniku"
    end
    redirect_to action: :show, id: comment.post, controller: :posts
  end

  def vote_down
    comment = Comment.find(params[:id])
    vote = Vote.new comment: comment, user: current_user, value: -1
    if not vote.save
      flash[:notice] = "Nie można votować dwa razy drogi użytkowniku"
    end
    redirect_to action: :show, id: comment.post, controller: :posts
  end


  def mark_as_not_abusive
    comment = Comment.find(params[:id])
    comment.not_abusive!
    render action: :index
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end

end
