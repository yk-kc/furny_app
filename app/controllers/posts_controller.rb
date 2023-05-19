class PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿が作成されました"
      redirect_to posts_path
    else
      render :new
    end
  end

  def index
    @posts = Post.all.page(params[:page]).per(1).order(created_at: :desc)
  end

  def search
    @keyword = params[:keyword]
    @posts = Post.search(@keyword).order(created_at: :desc)
    @users = User.search(@keyword).order(created_at: :desc)
  end

  def category_result
    @categories = params[:category_id].present? ? Category.find(params[:category_id]).posts.order(created_at: :desc) : Post.all
    @category = Category.find(params[:category_id])
  end

  def tag_result
    @selected_color = params[:tag_ids].select {|k,v| v == "1"}.keys
    if params[:tag_ids]
      @posts = []
      params[:tag_ids].each do |key, value|
        @posts += Tag.find_by(name: key).posts if value == "1"
      end
      @posts.uniq!
    end
  end

  def timeline
    @feeds = Post.where(user_id: [current_user.id, *current_user.following_ids]).order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
    respond_to do |format|
      format.html
      # link_toメソッドをremote: trueに設定したのでリクエストはjs形式で行われる
      format.js
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "投稿を編集しました。"
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:success] = "削除しました"
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:furniture_name, :caption, :category_id, images: [], tag_ids: []) # 複数画像、複数タグなので配列で受け取る
  end

end
