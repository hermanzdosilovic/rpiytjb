module Api
  class BaseController < RocketPants::Base
    def play
      filename = YouTubeDownloader.download(params[:url])
      AudioService.stop
      AudioService.play(filename)
      head :ok
    end
  end
end
