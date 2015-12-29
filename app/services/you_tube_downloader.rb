module YouTubeDownloader
  def self.download(url)
    return nil if url.nil? || url.match("https://www.youtube.com/").nil?
    `rm audio.m4a`
    `youtube-dl -x -o "audio.%(ext)s" -r 4.2M --buffer-size 16K --no-resize-buffer -q --audio-format m4a --postprocessor-args "-strict experimental" #{url}`
    JSON.parse(`youtube-dl -j #{url}`)
  end
end
