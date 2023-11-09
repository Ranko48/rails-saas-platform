# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.text :content
      t.string :url
      t.boolean :has_read, default: false
      t.timestamps
    end
  end
end
