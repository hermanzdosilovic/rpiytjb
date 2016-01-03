class AddUrlsToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :video_url, :text
    add_column :videos, :download_url, :text
  end
end
