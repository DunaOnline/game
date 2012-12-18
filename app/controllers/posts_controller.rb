class PostsController < ApplicationController
  before_filter :login_required
  
  def index
    #@posts = Post.all
  end

  def show
    admin_or_owner_required(post.user.id)
  end

  def new
  end

  def create
    @topic = Topic.find(params[:post][:topic_id])
    if @topic.posts.create(:content => params[:post][:content], :user_id => current_user.id)
      flash[:notice] = "Successfully created post."
      redirect_to @topic
    else
      render :action => 'new'
    end
  end

  def edit
    admin_or_owner_required(post.user.id)
  end

  def update
    admin_or_owner_required(post.user.id)
    if post.update_attributes(params[:post])
      flash[:notice] = "Successfully updated post."
      redirect_to post.topic
    else
      render :action => 'edit'
    end
  end

  def destroy
    admin_or_owner_required(post.user.id)
    @topic = Topic.find(post.topic_id)
    post.destroy
    redirect_to @topic, :notice => "Successfully destroyed post."
  end

  private

  def post
    @post ||= params[:id] ? Post.find(params[:id]) : Post.new(params[:post])
  end
  helper_method :post
end
