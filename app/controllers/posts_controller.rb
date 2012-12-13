class PostsController < ApplicationController
  before_filter :login_required 
  
  def index
    #@posts = Post.all
  end

  def show
    admin_or_owner_required(@post.user.id)
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @topic = Topic.where(:id => params[:post][:topic_id]).first
    if @topic.posts << Post.new(:content => params[:post][:content], :user_id => current_user.id)
      #@topic = Topic.find(@post.topic_id)
      @topic.update_attributes(:last_poster_id => current_user.id, :last_post_at => Time.now)
      flash[:notice] = "Successfully created post."
      redirect_to @topic
    else
      render :action => 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
    admin_or_owner_required(@post.user.id)
  end

  def update
    @post = Post.find(params[:id])
    admin_or_owner_required(@post.user.id)
    if @post.update_attributes(params[:post])
      @topic = Topic.find(@post.topic_id)
      @topic.update_attributes(:last_poster_id => current_user.id, :last_post_at => Time.now)
      flash[:notice] = "Successfully updated post."
      redirect_to "/topics/#{@post.topic_id}"  
    else
      render :action => 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    admin_or_owner_required(@post.user.id)
    @topic = Topic.find(@post.topic_id) 
    @post.destroy
    redirect_to @topic, :notice => "Successfully destroyed post."
  end
end
