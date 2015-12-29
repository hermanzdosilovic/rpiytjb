module AudioService
  def self.play(filename)
    fork { `#{APP_CONFIG['player']['start']} #{filename} && rm #{filename}` }
  end

  def self.stop
    `killall #{APP_CONFIG['player']['stop']}`
  end
end
