# frozen_string_literal: true

class Ticket < ApplicationRecord
  belongs_to :user
  has_many :ticket_comments
  has_one_attached :attachment

  enum :category, { how_to: 0, bug: 1, feature_request: 2, sales_question: 3, technical_issue: 4, cancellation: 5, other: 6 }
  validate :attachment_file
  def attachment_file
    return unless attachment.attached?

    return if attachment.blob.byte_size <= 10.megabyte

    errors.add(:attachment, 'cannot be more than 10MB')
  end
  validates :problem, presence: true, length: { minimum: 3, maximum: 1000 }
end
