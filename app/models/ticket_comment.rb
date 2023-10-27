# frozen_string_literal: true

class TicketComment < ApplicationRecord
  belongs_to :ticket
  belongs_to :user
  validates :comment, presence: true, length: { minimum: 3, maximum: 1000, too_long: ->(_obj, data) { "is too long (maximum is 1000 characters) - currently it's #{data[:value].length} characters" } }
end
