module Api
  class VideosController < BaseController
    def start
      Rails.application.mutex.synchronize do
        video = YouTubeDownloader.download(params[:url])
        head :bad_request and return if video.nil?

        last_playback = Playback.last
        AudioService.stop if last_playback.try(:is_playing)
        last_playback.try(:update, is_playing: false)

        playback = last_playback.try(:video_id) != video.id ?
          Playback.new(video_id: video.id) : last_playback
        playback.is_playing = true
        playback.save

        fork do
          AudioService.play(video, params[:volume])
          playback.update(is_playing: false)
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
      AudioService.force_stop
      Playback.update_all(is_playing: false)
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

    private

    def load_last_played_playback
      @last_playback = Playback.last_played
    end
  end
end
