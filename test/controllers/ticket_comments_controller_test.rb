# frozen_string_literal: true

require 'test_helper'

class TicketCommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    sign_in users(:bob)
    @ticket = tickets(:ticket_one)
  end

  test 'should create comment' do
    assert_difference('TicketComment.count') do
      post new_ticket_comment_url(@ticket.id, params: { ticket_comment: { comment: 'How do I delete my account?', ticket_id: @ticket.id } })
    end
  end
end
