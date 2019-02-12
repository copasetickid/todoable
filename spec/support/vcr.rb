require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data('<ENCODED AUTH HEADER>') { Base64.encode64("#{ENV.fetch('TODOABLE_USERNAME')}:#{ENV.fetch('TODOABLE_PASSWORD')}").chomp }
end