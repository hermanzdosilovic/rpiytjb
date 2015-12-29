# == Schema Information
#
# Table name: videos
#
#  id          :integer          not null, primary key
#  video_id    :string(255)
#  uploader_id :string(255)
#  title       :string(255)
#  description :text(65535)
#  created_at  :datetime
#  updated_at  :datetime
#

class Video < ActiveRecord::Base
  validates :video_id, :uploader_id, :title, :description, presence: true
  validates :video_id, uniqueness: true
end
