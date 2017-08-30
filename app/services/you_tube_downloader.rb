module YouTubeDownloader
  def self.fetch_info(url)
    return nil if url.nil? || url.match("https://www.youtube.com/").nil?

    info = JSON.parse(`bin/youtube-dl.sh #{url}`)
    video = Video.find_or_create_by(video_id: info['id']) do |v|
      v.title = info['title']
      v.description = info['description']
      v.uploader_id = info['uploader_id']
      v.download_url = info['url']
      v.video_url = url
    end
    video.update(download_url: info['url'])
    video
  end

  def self.download(url)
    return nil if url.nil? || url.match("https://www.youtube.com/").nil?

    video = fetch_info(url)
    `youtube-dl -x -o "audio/%(id)s.%(ext)s" -r 4.2M \
    --buffer-size 16K --no-resize-buffer --audio-format m4a #{url}` unless File.file?(video.audio_path)
    video
  end
end
