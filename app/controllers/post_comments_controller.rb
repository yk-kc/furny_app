class PostCommentsController < ApplicationController
  before_action :ensure_user, only: [:destroy]

  def create
    @post = Post.find(params[:post_id])
    comment = current_user.post_comments.new(post_comment_params)
    comment.post_id = @post.id
    comment.save
    @post.create_notification_comment!(current_user, comment.id)
    @post_comment = PostComment.new
  end

  def destroy
    PostComment.find_by(id: params[:id], post_id: params[:post_id]).destroy
    @post = Post.find(params[:post_id])
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end

  def ensure_user
    # current_userの全コメントの中に送られてきたコメントidがあるまたはcurrent_userがadminの場合
    @post_comments = current_user.post_comments
    @post_comment = @post_comments.find_by(id: params[:id]) || ( current_user.admin == true )
    redirect_to posts_path unless @post_comment
  end

end
