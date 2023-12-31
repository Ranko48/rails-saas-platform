# frozen_string_literal: true

class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ticket, only: %i[destroy]

  # GET /tickets or /tickets.json
  def index
    @tickets = Ticket.where(user_id: current_user.id)
  end

  # GET /tickets/1 or /tickets/1.json
  def show
    @ticket = Ticket.includes(:ticket_comments).find_by_id(params[:id])
    head(:unauthorized) if @ticket.user_id != current_user.id
    raise ActionController::RoutingError, 'Not Found' if @ticket.blank?
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
  end

  # POST /tickets or /tickets.json
  def create
    @ticket = Ticket.new(ticket_params.merge({ user_id: current_user.id }))

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to ticket_url(@ticket), notice: 'Ticket was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tickets/1 or /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to ticket_url(@ticket), notice: 'Your ticket was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1 or /tickets/1.json
  def destroy
    @ticket.resolved = true
    @ticket.save
    respond_to do |format|
      format.html { redirect_to ticket_url(@ticket), notice: 'Your ticket was successfully closed.' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_ticket
    @ticket = Ticket.find_by_id(params[:id])
    raise ActionController::RoutingError, 'Not Found' if @ticket.blank?
  end

  # Only allow a list of trusted parameters through.
  def ticket_params
    params.fetch(:ticket, {}).permit(:problem, :attachment)
  end
end
