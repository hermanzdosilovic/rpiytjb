# == Schema Information
#
# Table name: playbacks
#
#  id         :integer          not null, primary key
#  video_id   :integer
#  is_playing :boolean
#

class Playback < ActiveRecord::Base
  belongs_to :video

  def self.last_played
    where(is_playing: true).last
  end
end
