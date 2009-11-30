# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fetcher}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Luke Francl"]
  s.date = %q{2009-06-28}
  s.email = %q{look@recursion.org}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["fetcher.gemspec", "gemspec.rb", "init.rb", "lib", "lib/fetcher", "lib/fetcher/base.rb", "lib/fetcher/imap.rb", "lib/fetcher/pop.rb", "lib/fetcher.rb", "lib/vendor", "lib/vendor/plain_imap.rb", "lib/vendor/secure_pop.rb", "MIT-LICENSE", "Rakefile", "README.rdoc", "test", "test/fetcher_test.rb"]
  s.homepage = %q{http://github.com/winton/fetcher}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{download email from POP3 or IMAP and do stuff with it. gemified fork}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
