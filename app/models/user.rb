# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tickets

  validates :timezone, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }
  validates :first_name, presence: true, length: { minimum: 2, maximum: 300 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 300 }

  def full_name
    "#{first_name} #{last_name}"
  end
end
