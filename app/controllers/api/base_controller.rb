module Api
  class BaseController < RocketPants::Base
    def play
      filename = YouTubeDownloader.download(params[:url])
      head :bad_request and return if filename.nil?
      AudioService.stop
      AudioService.play(filename)
      head :ok
    end

    def stop
      AudioService.stop
      head :ok
    end
  end
end
