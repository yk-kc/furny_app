class PostsController < ApplicationController

  def new
    @post = Post.new
    @color_map = {
      "レッド": "#CC0D0D",
      "ブルー": "#2F6DCB",
      "グリーン": "#008000",
      "イエロー": "#E7C724",
      "オレンジ": "#CF7F08",
      "ピンク": "#CF0867",
      "パープル": "#3E1F98",
      "ベージュ": "#C7AC8E",
      "ダークブラウン": "#4B2B06",
      "ウォールナットブラウン": "#7E4D14",
      "ミディアムブラウン": "#B75A05",
      "ライトブラウン": "#E0AC7B",
      "ブラック": "#000000",
      "グレー": "#999595",
      "ホワイト": "#ffffff",
      "アイボリー": "#FFFBEE",
      "クリア": "#F2F8FA",
      "ゴールド": "#D8CCAD",
      "シルバー": "#D3D3D3",
    }
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
    @posts = Post.all.order(created_at: :desc)
    @categories = params[:category_id].present? ? Category.find(params[:category_id]).posts : Post.all
    @color_map = {
      "レッド": "#CC0D0D",
      "ブルー": "#2F6DCB",
      "グリーン": "#008000",
      "イエロー": "#E7C724",
      "オレンジ": "#CF7F08",
      "ピンク": "#CF0867",
      "パープル": "#3E1F98",
      "ベージュ": "#C7AC8E",
      "ダークブラウン": "#4B2B06",
      "ウォールナットブラウン": "#7E4D14",
      "ミディアムブラウン": "#B75A05",
      "ライトブラウン": "#E0AC7B",
      "ブラック": "#000000",
      "グレー": "#999595",
      "ホワイト": "#ffffff",
      "アイボリー": "#FFFBEE",
      "クリア": "#F2F8FA",
      "ゴールド": "#D8CCAD",
      "シルバー": "#D3D3D3",
    }
  end

  def search
    @keyword = params[:keyword]
    @posts = Post.search(@keyword).order(created_at: :desc)
    @users = User.search(@keyword).order(created_at: :desc)
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
    @color_map = {
      "レッド": "#CC0D0D",
      "ブルー": "#2F6DCB",
      "グリーン": "#008000",
      "イエロー": "#E7C724",
      "オレンジ": "#CF7F08",
      "ピンク": "#CF0867",
      "パープル": "#3E1F98",
      "ベージュ": "#C7AC8E",
      "ダークブラウン": "#4B2B06",
      "ウォールナットブラウン": "#7E4D14",
      "ミディアムブラウン": "#B75A05",
      "ライトブラウン": "#E0AC7B",
      "ブラック": "#000000",
      "グレー": "#999595",
      "ホワイト": "#ffffff",
      "アイボリー": "#FFFBEE",
      "クリア": "#F2F8FA",
      "ゴールド": "#D8CCAD",
      "シルバー": "#D3D3D3",
    }
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
