# frozen_string_literal: true

class TicketComment < ApplicationRecord
  belongs_to :ticket
  belongs_to :user
  has_one_attached :attachment
  validate :attachment_file

  def attachment_file
    return unless attachment.attached?

    return if attachment.blob.byte_size <= 10.megabyte

    errors.add(:attachment, 'cannot be more than 10MB')
  end

  validates :comment, presence: true, length: { minimum: 3, maximum: 1000, too_long: ->(_obj, data) { "is too long (maximum is 1000 characters) - currently it's #{data[:value].length} characters" } }
end
