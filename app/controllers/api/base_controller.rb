module Api
  class BaseController < RocketPants::Base
    def play
      video_info = YouTubeDownloader.download(params[:url])
      head :bad_request and return if video_info.nil?
      AudioService.stop
      AudioService.play
      head :ok
    end

    def stop
      AudioService.stop
      head :ok
    end
  end
end
