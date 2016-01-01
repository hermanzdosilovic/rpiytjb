APP_CONFIG = YAML.load(ERB.new(File.read(Rails.root.join('config/config.yml'))).result)[Rails.env]
begin
  File.delete(APP_CONFIG['pipe'])
rescue
end
