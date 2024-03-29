class PostsController < ApplicationController
  before_filter :authenticate_user!
  expose_decorated(:posts) { Post.all }
  expose_decorated(:post, attributes: :post_params)
  expose_decorated(:comments) {
    current_user != post.user ? post.comments.select { |c| not c.abusive } : post.comments
  }
  expose(:tag_cloud) { [["bar", 1.0], ["foo", 2.0]]}

  def index
  end

  def new
  end

  def edit
  end

  def update
    if post.save
      render action: :index
    else
      render :new
    end
  end

  def destroy
    post.destroy if current_user.posts.include? post
    render action: :index
  end

  def show
  end

  def mark_archived
    # post = Post.find params[:id]
    post.archive!
    render action: :index
  end

  def create
    post.user = current_user
    if post.save
      redirect_to action: :index
    else
      render :new
    end
  end

  private

  def post_params
    return if %w{mark_archived}.include? action_name
    params.require(:post).permit(:body, :title, :tags)
  end
end
