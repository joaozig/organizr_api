class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.datetime :due_date
      t.references :list, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
