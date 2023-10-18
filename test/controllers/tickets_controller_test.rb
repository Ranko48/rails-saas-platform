# frozen_string_literal: true

require 'test_helper'

class TicketsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    sign_in users(:bob)
    @ticket = tickets(:ticket_one)
  end

  test 'should get index' do
    get tickets_url
    assert_response :success
  end

  test 'should get new' do
    get new_ticket_url
    assert_response :success
  end

  test 'should create ticket' do
    assert_difference('Ticket.count') do
      post tickets_url, params: { ticket: { problem: 'How do I delete my account?' } }
    end

    assert_redirected_to ticket_url(Ticket.last)
  end

  test 'should show ticket' do
    get ticket_url(@ticket)
    assert_response :success
  end

  test 'should destroy ticket' do
    assert_difference('Ticket.count', -1) do
      delete ticket_url(@ticket)
    end

    assert_redirected_to tickets_url
  end
end
