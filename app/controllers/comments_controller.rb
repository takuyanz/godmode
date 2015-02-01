class CommentsController < ApplicationController
  before_action :authenticate
  
  def create
    commented_user_id = params.require(:user_id)
    comment = params.require(:comment)
    @comment = current_user.comments.build(commented_user_id: commented_user_id, comment: comment)

    if @comment.save
      render partial: "new_comment"
    else
      render status: 500
    end
  end

  def show
    user_id = params.require(:id)
    @comments = Comment.where(commented_user_id: user_id).includes(:user).includes(replies: :user).order("created_at DESC")
    @user = User.find(user_id)

    render partial: "show_comments"
  end

  def destroy
    Comment.find(params.require(:id)).destroy
    render nothing: true 
  end
end
