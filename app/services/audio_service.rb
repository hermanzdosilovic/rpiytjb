module AudioService
  def self.play
    fork { `#{APP_CONFIG['player']['start']} audio.m4a && rm audio.m4a` }
  end

  def self.stop
    `killall #{APP_CONFIG['player']['stop']} && rm audio.m4a`
  end
end
