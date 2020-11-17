class CreateUploads < ActiveRecord::Migration[6.0]
  def change
    create_table :uploads do |t|
      t.string :csv
      t.boolean :ready, default: false
      t.text :errors

      t.timestamps
    end
  end
end
