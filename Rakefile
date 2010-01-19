require 'rubygems'

gems = [
  [ 'active_wrapper', '=0.2.3' ],
  [ 'cucumber', '=0.6.1' ],
  [ 'rspec', '=1.2.9' ]
]

gems.each do |name, version|
  if File.exists?(path = "#{File.dirname(__FILE__)}/../vendor/#{name}/lib")
    $:.unshift path
  else
    gem name, version
  end
end

require 'rake'
require 'active_wrapper/tasks'
require 'cucumber/rake/task'
require 'rake/gempackagetask'
require 'spec/rake/spectask'
require 'gemspec'

ActiveWrapper::Tasks.new(
  :base => File.dirname(__FILE__),
  :env => ENV['ENV']
)

desc "Generate gemspec"
task :gemspec do
  File.open("#{Dir.pwd}/#{GEM_NAME}.gemspec", 'w') do |f|
    f.write(GEM_SPEC.to_ruby)
  end
end

desc "Install gem"
task :install do
  Rake::Task['gem'].invoke
  `sudo gem uninstall #{GEM_NAME} -x`
  `sudo gem install pkg/#{GEM_NAME}*.gem`
  `rm -Rf pkg`
end

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = "--format pretty"
end

Rake::GemPackageTask.new(GEM_SPEC) do |pkg|
  pkg.gem_spec = GEM_SPEC
end

Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ["--format", "specdoc", "--colour"]
  t.spec_files = FileList["spec/**/*_spec.rb"]
end