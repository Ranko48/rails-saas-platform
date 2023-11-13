# frozen_string_literal: true

class TicketCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ticket, only: %i[new]

  def set_ticket
    @ticket = Ticket.find_by_id(params[:ticket_id])
    raise ActionController::RoutingError, 'Not Found' if @ticket.blank?
  end

  def new
    format.html { redirect_to ticket_url(@ticket), notice: 'Comment could not be added.' } if @ticket.resolved
    @comment = TicketComment.new(ticket_comment_params.merge({ user_id: current_user.id, ticket_id: @ticket.id }))
    respond_to do |format|
      if @comment.save
        @comment.broadcast_append_to(@ticket, :ticket_comments, locals: { ticket_comment: @comment })
        format.html { redirect_to ticket_url(@ticket), notice: 'Comment was successfully added.' }
        format.turbo_stream
      else
        format.html { redirect_to ticket_url(@ticket), notice: 'Comment could not be added.' }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("form_ticket_#{@ticket.id}", partial: 'ticket_comments/ticket_comment_form', locals: { ticket_comment: @comment })
        end
      end
    end
  end

  private

  def ticket_comment_params
    params.fetch(:ticket_comment, {}).permit(:comment, :attachment)
  end
end
