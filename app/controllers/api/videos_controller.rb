module Api
  class VideosController < BaseController
    def start
      video = YouTubeDownloader.download(params[:url])
      head :bad_request and return if video.nil?
      AudioService.stop
      AudioService.play(video)
      head :ok
    end

    def stop
      AudioService.stop
      head :ok
    end

    def pause
      AudioService.pause
      head :ok
    end

    def volume
      AudioService.volume(params[:value])
      head :ok
    end
  end
end
