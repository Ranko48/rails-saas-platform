# frozen_string_literal: true

class Notification < ApplicationRecord
  include ActionView::RecordIdentifier
  belongs_to :user

  validates :content, presence: true, length: { minimum: 3, maximum: 250 }

  # Turbo logic for notifications

  def broadcast_notification_updates
    broadcast_update_to(
      user,
      :notifications,
      partial: 'components/notification/notification_button',
      target: 'notification_btn',
      locals: { notification_count: user.notifications.where(has_read: false).count }
    )
  end

  after_create_commit do
    broadcast_prepend_to(
      user,
      :notifications,
      partial: 'components/notification/notification',
      target: 'notifications'
    )
  end

  after_save_commit do
    broadcast_notification_updates
    if has_read
      broadcast_remove_to(
        user,
        :notifications,
        target: dom_id(self)
      )
    end
  end

  after_destroy_commit do
    broadcast_remove_to(
      user,
      :notifications,
      target: dom_id(self)
    )
    broadcast_notification_updates
  end
end
