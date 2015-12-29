module AudioService
  def self.play(video)
    `touch #{APP_CONFIG['pipe']}`
    fork { `mplayer -slave -input file=#{APP_CONFIG['control']} -volume 40 #{video.audio_path}` }
  end

  def self.stop
    return unless pipe_used?
    `echo "quit" > #{APP_CONFIG['control']}`
    `rm #{APP_CONFIG['pipe']}`
  end

  def self.pause
    return unless pipe_used?
    `echo "pause" > #{APP_CONFIG['control']}`
  end

  def self.volume(value)
    return unless pipe_used?
    value = value.to_i
    value = 0 if value < 0
    value = 100 if value > 100
    `echo "volume #{value} 1" > #{APP_CONFIG['control']}`
  end

  private

  def self.pipe_used?
    File.file?(APP_CONFIG['pipe'])
  end
end
