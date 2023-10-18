# frozen_string_literal: true

class Ticket < ApplicationRecord
  belongs_to :user
  validates :problem, presence: true, length: { minimum: 3, maximum: 1000 }
end
