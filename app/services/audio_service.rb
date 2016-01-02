class AudioService
  DEFAULT_VOLUME = 50

  attr_reader :video
  attr_reader :now_playing

  def initialize(video, volume = DEFAULT_VOLUME)
    @video = video
    @volume = (volume || DEFAULT_VOLUME).to_i
    @now_playing = false
  end

  def play
    @now_playing = true
    `mplayer -slave -input file=#{APP_CONFIG['control']} -nolirc -volume #{@volume} #{@video.audio_path}`
    @now_playing = false
  end

  def stop
    `echo "quit" > #{APP_CONFIG['control']}`
  end

  def pause
    `echo "pause" > #{APP_CONFIG['control']}`
  end

  def change_volume(value)
    value = value.to_i
    value = 0 if value < 0
    value = 100 if value > 100
    @volume = value
    `echo "volume #{value} 1" > #{APP_CONFIG['control']}`
    @volume
  end
end
