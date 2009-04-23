# JRuby on Rails on GAE Template
run 'jruby -S gem install warbler' if yes?('Install warbler gem?')
# ready to warble
run 'jruby -S warble pluginize'
run 'jruby -S warble config'

file 'config/warble.rb', <<-TOF
Warbler::Config.new do |config|
  config.dirs = %w(app config lib log vendor tmp)
  config.includes = FileList["appengine-web.xml"]
  config.java_libs = []
  config.gem_dependencies = true
  config.webxml.jruby.min.runtimes = 1
  config.webxml.jruby.max.runtimes = 1
  config.webxml.jruby.init.serial = true
end
TOF

app_name = Dir.pwd.split('/').last
run "rm #{app_name}.war"
run 'rm -r tmp/war'
run 'rm -r vendor/rails'
run 'rake rails:freeze:gems'

# create appengine-web.xml
file 'appengine-web.xml', <<-TOF
<?xml version="1.0" encoding="utf-8"?>

<appengine-web-app xmlns="http://appengine.google.com/ns/1.0">
  <application>#{app_name}</application>
  <version>2</version>

  <static-files />
  <resource-files />
  <sessions-enabled>true</sessions-enabled>
  <system-properties>
    <property name="jruby.management.enabled" value="false" />
    <property name="os.arch" value="" />
    <property name="jruby.compile.mode" value="JIT"/> <!-- JIT|FORCE|OFF -->
    <property name="jruby.compile.fastest" value="true"/>
    <property name="jruby.compile.frameless" value="true"/>
    <property name="jruby.compile.positionless" value="true"/>
    <property name="jruby.compile.threadless" value="false"/>
    <property name="jruby.compile.fastops" value="false"/>
    <property name="jruby.compile.fastcase" value="false"/>
    <property name="jruby.compile.chainsize" value="500"/>
    <property name="jruby.compile.lazyHandles" value="false"/>
    <property name="jruby.compile.peephole" value="true"/>
  </system-properties>
</appengine-web-app>
TOF

file 'datastore-indexes.xml',
%q{
<?xml version="1.0" encoding="utf-8"?>
  <datastore-indexes autoGenerate="true">
</datastore-indexes>
}

inside('lib') do
  run 'git clone git://github.com/gom/hello-gae-gom.git'
  run 'cp hello-gae-gom/lib/*.jar . && rm -rf hello-gae-gom'

  #run 'git clone git://github.com/olabini/bumble.git'
  #run 'git clone git://github.com/olabini/beeu.git'
end

# remove unuse files
# notice: if you'll remove these files, you can't use rake commands
run 'rm -rf test/'
run 'rm -rf doc/'
%w(doc html bin builtin environments dispatches).each do |files|
  run %Q{rm -rf vendor/rails/railties/#{files}}
end
run 'rm -rf vendor/rails/activerecord'
%w(actionmailer actionpack activeresource activesupport railties).each do |gem|
  run %Q{rm -rf vendor/rails/#{gem}/test}
end

# warble
run 'warble war'
