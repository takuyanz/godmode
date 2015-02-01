class RepliesController < ApplicationController

  def create
    comment_id = params.require(:comment_id)
    reply = params.require(:reply)
    @reply = Reply.new(comment_id: comment_id, reply_text: reply, user_id: current_user.id)

    if @reply.save
      render partial: 'new_reply'
    else
      render status: 500
    end
  end

  def show
  end
end
