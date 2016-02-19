module Api
  class VideosController < BaseController
    def start
      Rails.application.start_mutex.synchronize do
        video = YouTubeDownloader.fetch_info(params[:url])
        head :bad_request and return if video.nil?

        stop

	Thread.new do
	  Rails.application.playback_mutex.synchronize do
            last_playback = Playback.last
            playback = last_playback
	    if last_playback.try(:video_id) != video.id
              playback = Playback.create(video_id: video.id, is_playing: true)
	    else
	      playback.update(is_playing: true)
	    end
	
	    AudioService.stream(video, params[:volume])
	    playback.update(is_playing: false)
          end
	end

        expose video
      end
    end

    def stop
      load_last_played_playback
      unless @last_playback.try(:is_playing)
        expose nil
        return
      end

      AudioService.stop
      @last_playback.update(is_playing: false)
      expose nil
    end

    def force_stop
      Playback.update_all(is_playing: false)
      AudioService.force_stop
      expose nil
    end

    def pause
      load_last_played_playback
      unless @last_playback.try(:is_playing)
        expose nil
        return
      end

      AudioService.pause
      expose @last_playback.video
    end

    def volume
      load_last_played_playback
      unless @last_playback.try(:is_playing)
        expose nil
        return
      end

      AudioService.change_volume(params[:value])
      expose @last_playback.video
    end

    def now
      load_last_played_playback
      expose @last_playback.try(:video)
    end
 
    def position
      load_last_played_playback
      unless @last_playback.try(:is_playing)
        expose nil
        return
      end

      expose position: AudioService.position, server_time: Time.now.strftime("%H:%M:%S")
    end

    private

    def load_last_played_playback
      @last_playback = Playback.last_played
    end
  end
end
