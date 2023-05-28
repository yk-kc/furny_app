class PostsController < ApplicationController
  before_action :ensure_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿が作成されました"
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def index
    @posts = Post.all.page(params[:page]).per(12).order(created_at: :desc)
  end

  def search
    @keyword = params[:keyword]
    @posts = Post.search(@keyword).page(params[:page]).per(12).order(created_at: :desc)
    @users = User.search(@keyword).page(params[:page]).per(12).order(created_at: :desc)
  end

  def category_result
    category_id = params[:category_id]
    if  category_id.present?
      @category = Category.find(category_id)
      @categories = Category.find(category_id).posts.
                             page(params[:page]).per(12).
                             order(created_at: :desc)
      # .pluckは特定のカラムのみを配列で取り出せるメソッド
      # .uniqは重複レコードを1つにまとめて取得できる
      target_tag_ids = PostTagRelation.where(post_id: Category.find(category_id).posts.ids).
                                       pluck(:tag_id).uniq.sort
      @tag_names = Tag.find(target_tag_ids).pluck(:name)
    else
      @posts = Post.all.page(params[:page]).per(12).order(created_at: :desc)
      render :index
    end
  end

  def tag_result
    @selected_color = params[:tag_ids].select {|k,v| v == "1"}.keys
    if params[:tag_ids]
      @posts = []
      # カテゴリー検索結果一覧から色タグ検索
      if params[:category_id]
        params[:tag_ids].each do |key, value|
          @posts += Tag.find_by(name: key).posts.where(category_id: params[:category_id]) if value == "1"
        end
      else
        # 投稿一覧から色タグ検索
        params[:tag_ids].each do |key, value|
          @posts += Tag.find_by(name: key).posts if value == "1"
        end
      end
      @posts.uniq!
      @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(12)
    end
  end

  def timeline
    @feeds = Post.where(user_id: [current_user.id, *current_user.following_ids]).page(params[:page]).per(12).order(created_at: :desc)
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
      flash[:notice] = "投稿を編集しました"
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.images.purge
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to user_path(current_user)
  end

  def upload_image
    @image_blob = create_blob(params[:image])
    respond_to do |format|
      format.json { @image_blob.id }
    end
  end

  private

  def post_params
  # 複数タグなので配列で受け取る
    params.require(:post).permit(:furniture_name, :caption, :category_id, tag_ids: []).merge(images: uploaded_images)
  end

  def uploaded_images
    params[:post][:images].map{|id| ActiveStorage::Blob.find(id)} if params[:post][:images]
  end

  def create_blob(uploading_file)
    ActiveStorage::Blob.create_after_upload! \
      io: uploading_file.open,
      filename: uploading_file.original_filename,
      content_type: uploading_file.content_type
  end

  def ensure_user
    # current_userの全投稿の中に送られてきた投稿idがあるまたはcurrent_userがadminの場合
    @posts = current_user.posts
    @post = @posts.find_by(id: params[:id]) || ( current_user.admin == true )
    redirect_to posts_path unless @post
  end

end
