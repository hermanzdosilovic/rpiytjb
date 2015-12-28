module Api
  class BaseController < RocketPants::Base
    def play
      filename = `youtube-dl #{params[:url]} --get-id`.strip + '.mp3'
      `youtube-dl -x --id --audio-format mp3 #{params[:url]}` unless File.file?(filename)
      `killall #{APP_CONFIG['audio_player']}`
      fork { `#{APP_CONFIG['audio_player']} #{filename}` }
      head :ok
    end
  end
end
