class AudioService
  DEFAULT_VOLUME = 50
  CONTROL = Rails.root.join("bin/dbuscontrol.sh")
  RADIO = Rails.root.join("bin/fm_transmitter")

  def self.stream(video, volume = DEFAULT_VOLUME)
    volume = fix_volume(volume || DEFAULT_VOLUME)/100.0
    volume += 0.00001
    volume = 2000.0 * Math.log10(volume)
    `omxplayer --audio_queue=10 --vol #{volume} "#{video.download_url}"`
  end
  
  def self.radio(video)
    `wget -qO - "#{video.download_url}" | avconv -y -i pipe:0 -vn -q:a 5 -f wav -ar 22050 -ac 1 pipe:1 | sudo #{RADIO} -f 108.0 -`
  end

  def self.stop
    `#{CONTROL} stop`
    `sudo killall fm_transmitter`
  end

  def self.force_stop
    `killall -9 omxplayer.bin`
    `sudo killall fm_transmitter`
  end

  def self.pause
    `#{CONTROL} pause`
  end

  def self.change_volume(value)
    volume = fix_volume(value)
    `#{CONTROL} volume #{volume/100.0}`
    volume
  end
  
  def self.position
    microseconds = `#{CONTROL} position`.to_i
    seconds = microseconds / 10**6
    minutes = seconds / 60
    hours = minutes / 60
    seconds %= 60
    sprintf "%02d:%02d:%02d", hours, minutes, seconds
  end

  private

  def self.fix_volume(value)
    value = value.to_i
    value = 0 if value < 0
    value = 100 if value > 100
    value
  end
end
