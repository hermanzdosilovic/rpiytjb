module Api
  class VideosController < BaseController
    def play
      video_info = YouTubeDownloader.download(params[:url])

      head :bad_request and return if video_info.nil?

      Video.create(video_attributes(video_info))
      AudioService.stop
      AudioService.play

      head :ok
    end

    def stop
      AudioService.stop
      head :ok
    end

    private

    def video_attributes(info)
      attributes = info.slice('title', 'description', 'uploader_id')
      attributes[:video_id] = info['id']
      attributes
    end
  end
end
