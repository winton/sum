GEM_NAME = 'fetcher'
GEM_FILES = FileList['**/*'] - FileList['coverage', 'coverage/**/*', 'pkg', 'pkg/**/*']
GEM_SPEC = Gem::Specification.new do |s|
  # == CONFIGURE ==
  s.author = "Luke Francl"
  s.email = "look@recursion.org"
  s.homepage = "http://github.com/winton/#{GEM_NAME}"
  s.summary = "download email from POP3 or IMAP and do stuff with it. gemified fork"
  # == CONFIGURE ==
  s.extra_rdoc_files = [ "README.rdoc" ]
  s.files = GEM_FILES.to_a
  s.has_rdoc = false
  s.name = GEM_NAME
  s.platform = Gem::Platform::RUBY
  s.require_path = "lib"
  s.version = "0.1.2"
end
