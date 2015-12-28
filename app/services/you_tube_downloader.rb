module YouTubeDownloader
  def self.download(url)
    filename = `youtube-dl #{url} --get-id`.strip + '.mp3'
    `youtube-dl -x --id --audio-format mp3 #{url}` unless File.file?(filename)
    filename
  end
end
