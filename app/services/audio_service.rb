class AudioService
  DEFAULT_VOLUME = 50
  CONTROL = Rails.root.join("bin/dbuscontrol.sh")

  def self.stream(video, volume = DEFAULT_VOLUME)
    volume = fix_volume(volume || DEFAULT_VOLUME)/100.0
    volume += 0.00001
    volume = 2000.0 * Math.log10(volume)
    `omxplayer --audio_queue=10 --vol #{volume} "#{video.download_url}"`
  end

  def self.stop
    `#{CONTROL} stop`
  end

  def self.force_stop
    `killall -9 omxplayer.bin`
  end

  def self.pause
    `#{CONTROL} pause`
  end

  def self.change_volume(value)
    volume = fix_volume(value)
    `#{CONTROL} volume #{volume/100.0}`
    volume
  end

  private

  def self.fix_volume(value)
    value = value.to_i
    value = 0 if value < 0
    value = 100 if value > 100
    value
  end
end
