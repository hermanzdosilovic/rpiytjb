module AudioService
  def self.play(video)
    fork { `#{APP_CONFIG['player']['start']} #{video.audio_path}` }
  end

  def self.stop
    `killall #{APP_CONFIG['player']['stop']}`
  end
end
