class AudioService
  DEFAULT_VOLUME = 50
  CONTROL = Rails.root.join("bin/dbuscontrol.sh")
  RADIO = Rails.root.join("bin/fm_transmitter")
  PLAYER = Rails.root.join("bin/omxplayer.sh")

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
    `sudo #{CONTROL} stop 2>/dev/null`
    # `sudo killall fm_transmitter 2>/dev/null`
  end

  def self.force_stop
    `sudo killall omxplayer.bin`
    # `sudo killall fm_transmitter 2>/dev/null`
  end

  def self.pause
    run("sudo #{CONTROL} pause 2>/dev/null")
  end

  def self.change_volume(value)
    volume = fix_volume(value)
    run("sudo #{CONTROL} volume #{volume/100.0} 2>/dev/null")
    volume
  end
  
  def self.current_position
    microseconds = run("sudo #{CONTROL} position 2>/dev/null").to_i
    seconds = microseconds/10**6
    sprintf "%02d:%02d:%02d", seconds/3600, seconds%3600/60, seconds%3600%60
  end

  private

  def self.fix_volume(value)
    value = value.to_i
    value = 0 if value < 0
    value = 100 if value > 100
    value
  end

  def self.run(command)
    `#{command}`#; while [ $? -ne 0 ]; do #{command}; done`
  end
end
