module YouTubeDownloader
  def self.download(url)
    return nil if url.nil? || url.match("https://www.youtube.com/").nil?
    about = JSON.parse(`youtube-dl -j #{url}`)
    filename = about['id'] + '.m4a'
    `youtube-dl -x --id -r 4.2M --buffer-size 16K --no-resize-buffer -q --audio-format m4a #{url}` unless File.file?(filename)
    filename
  end
end
