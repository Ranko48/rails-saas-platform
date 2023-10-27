# frozen_string_literal: true

class AddCategoryToTicket < ActiveRecord::Migration[7.1]
  def change
    add_column :tickets, :category, :integer, default: 0
  end
end
