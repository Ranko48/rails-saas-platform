# frozen_string_literal: true

class CreateTicketComments < ActiveRecord::Migration[7.1]
  def change
    create_table :ticket_comments do |t|
      t.references :ticket, null: false, foreign_key: { on_delete: :cascade }
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.text :comment
      t.timestamps
    end
  end
end
