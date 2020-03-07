Gem::Specification.new do |s|
  s.name = 'htmlbook'
  s.version = '0.1.2'
  s.summary = 'Splits HTML content into pages suitable for printing.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/htmlbook.rb']
  s.add_runtime_dependency('qnd_html2page', '~> 0.2', '>=0.2.0')
  s.signing_key = '../privatekeys/htmlbook.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/htmlbook'
end
