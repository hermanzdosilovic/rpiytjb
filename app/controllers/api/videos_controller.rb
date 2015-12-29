module Api
  class VideosController < BaseController
    def play
      video = YouTubeDownloader.download(params[:url])
      head :bad_request and return if video.nil?

      AudioService.stop
      AudioService.play(video)

      expose video
    end

    def stop
      AudioService.stop
      head :ok
    end
  end
end
