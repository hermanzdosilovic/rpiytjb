class CreateVideo < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :video_id
      t.string :uploader_id
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
