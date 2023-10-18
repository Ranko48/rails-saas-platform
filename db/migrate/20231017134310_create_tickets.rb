# frozen_string_literal: true

class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.text :problem
      t.boolean :resolved, default: false
      t.timestamps
    end
  end
end
