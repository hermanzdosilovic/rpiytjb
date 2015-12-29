module YouTubeDownloader
  def self.download(url)
    return nil if url.nil? || url.match("https://www.youtube.com/").nil?

    info = JSON.parse(`youtube-dl -j #{url}`)
    video = Video.new(video_info(info))

    `youtube-dl -x -o "audio/%(id)s.%(ext)s" -r 4.2M \
    --buffer-size 16K --no-resize-buffer --audio-format m4a \
    --postprocessor-args "-strict experimental" #{url} 1>&2` unless File.file?(video.audio_path)

    video.save
    Video.find_by(video_id: video.video_id)
  end

  private

  def self.video_info(info)
    attributes = info.slice('title', 'description', 'uploader_id')
    attributes[:video_id] = info['id']
    attributes
  end
end
