class AudioService
  DEFAULT_VOLUME = 50
  CONTROL = Rails.root.join("bin/dbuscontrol.sh")
  RADIO = Rails.root.join("bin/fm_transmitter")
  PLAYER = Rails.root.join("bin/omx")

  def self.stream(video, volume = DEFAULT_VOLUME)
    volume = fix_volume(volume || DEFAULT_VOLUME)/100.0
    volume += 0.00001
    volume = 2000.0 * Math.log10(volume)
    `#{PLAYER} #{volume} "#{video.download_url}"` # params: volume, url
  end
  
  def self.radio(video)
    `wget -qO - "#{video.download_url}" | avconv -y -i pipe:0 -vn -q:a 5 -f wav -ar 22050 -ac 1 pipe:1 | sudo #{RADIO} -f 108.0 -`
  end

  def self.stop
    `killall omx 2> /dev/null && killall omxplayer.bin 2> /dev/null`
    `sudo killall fm_transmitter 2> /dev/null`
  end

  def self.force_stop
    `killall -9 omx 2> /dev/null && killall -9 omxplayer.bin 2> /dev/null`
    `sudo killall fm_transmitter 2> /dev/null`
  end

  def self.pause
    `#{CONTROL} pause`
  end

  def self.change_volume(value)
    volume = fix_volume(value)
    `#{CONTROL} volume #{volume/100.0}`
    volume
  end
  
  def self.current_position
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
