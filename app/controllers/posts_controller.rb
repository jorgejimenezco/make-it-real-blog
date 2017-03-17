class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :is_admin?, only: [ :new, :create, :edit, :update, :destroy ]
  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      flash[:notice] = 'Post has been updated successfully'
      redirect_to posts_path
    else
      flash[:alert] = 'Failed, Post has not been updated'
      render :edit
    end

  end

  def index
    @posts = Post.all
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = 'Post has been eliminated'
    redirect_to posts_path
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
    @comment = Comment.new
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      flash[:notice] = 'Post was created successfully'
      redirect_to posts_path
    else
      flash[:alert] = ' Failed, Post was not created'
      render :new
    end
  end

private

  def post_params
    params.require(:post).permit(:author, :title, :content)
  end

  def is_admin?
    unless current_user.admin?
    flash[:alert] = 'You do not have permission to access'
    end
  end
end
