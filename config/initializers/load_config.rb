APP_CONFIG = YAML.load_file(Rails.root.join('config/config.yml'))[Rails.env]
begin
  File.delete(APP_CONFIG['pipe'])
rescue
end
