module Api
  class VideosController < BaseController
    def start
      load_application

      @application.mutex.synchronize do
        video = YouTubeDownloader.download(params[:url])
        head :bad_request and return if video.nil?

        @application.audio_service.try(:stop)
        @application.audio_service = AudioService.new(video, params[:volume])

        Thread.new do
          @application.audio_service.play
          @application.remove_audio_service
        end

        expose @application.audio_service
      end
    end

    def stop
      load_application
      @application.audio_service.try(:stop)
      @application.remove_audio_service
      expose @application.audio_service
    end

    def pause
      load_application
      @application.audio_service.try(:pause)
      expose @application.audio_service
    end

    def volume
      load_application
      @application.audio_service.try(:change_volume, params[:value])
      expose @application.audio_service
    end

    def now
      load_application
      expose @application.audio_service
    end

    private

    def load_application
      @application = Rails.application
    end
  end
end
