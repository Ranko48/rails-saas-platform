# frozen_string_literal: true

require 'test_helper'

class NotificationControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    sign_in users(:bob)
    @notification = notifications(:notification_one)
  end

  test 'should mark notification as read' do
    assert_changes('@notification.has_read') do
      post notification_mark_as_read_url
      @notification.reload
    end
  end

  test 'should return redirect response to url' do
    get notification_redirect_path(@notification.id)
    assert_redirected_to(/#{@notification.url}/, status: :redirect)
  end
end
