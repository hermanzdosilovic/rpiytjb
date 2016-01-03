class CreatePlayback < ActiveRecord::Migration
  def change
    create_table :playbacks do |t|
      t.integer :video_id
      t.boolean :is_playing
    end
  end
end
