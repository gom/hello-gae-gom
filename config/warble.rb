Warbler::Config.new do |config|
  config.dirs = %w(app config lib log vendor tmp)
  config.includes = FileList["appengine-web.xml"]
  config.java_libs = []
  config.gem_dependencies = true
  config.webxml.jruby.min.runtimes = 1
  config.webxml.jruby.max.runtimes = 1
  config.webxml.jruby.init.serial = true
end
