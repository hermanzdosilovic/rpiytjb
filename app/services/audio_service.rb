class AudioService
  DEFAULT_VOLUME = 50

  def self.play(video, volume = DEFAULT_VOLUME)
    volume = (volume || DEFAULT_VOLUME).to_i
    `mplayer -slave -input file=#{APP_CONFIG['control']} -nolirc -volume #{volume} #{video.audio_path}`
  end

  def self.stream(video, volume = DEFAULT_VOLUME)
    volume = (volume || DEFAULT_VOLUME).to_i
    Thread.new { `wget -q -O #{APP_CONFIG['stream']} #{video.download_url.shellescape}` }
    `mplayer -slave -input file=control -cache 1024 -volume 50 -nolirc #{APP_CONFIG['stream']}`
  end

  def self.stop
    `echo "quit" > #{APP_CONFIG['control']}`
  end

  def self.force_stop
    `killall mplayer`
  end

  def self.pause
    `echo "pause" > #{APP_CONFIG['control']}`
  end

  def self.change_volume(value)
    value = value.to_i
    value = 0 if value < 0
    value = 100 if value > 100
    `echo "volume #{value} 1" > #{APP_CONFIG['control']}`
    value
  end
end
