Rails.application.config.generators do |g|
  g.stylesheets false #CSS
  g.javascripts false #javascript
  g.helper false #Helper
  g.skip_routes true #Router
end

#不要なものを自動生成しないように制限をかける