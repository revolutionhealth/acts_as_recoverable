require 'rubygems'

require 'test/unit'
require 'mocha'

require 'active_support'
require 'active_record'
require 'active_record/fixtures'

require File.join(File.dirname(__FILE__), '..', 'init')

#FileUtils.rm(File.join(File.dirname(__FILE__), 'db', "./test.db"))
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => File.join(File.dirname(__FILE__), 'db', "./test.db"))

ActiveRecord::Base.logger = Logger.new File.join(File.dirname(__FILE__), 'log', 'test.log')

require File.join(File.dirname(__FILE__), 'fixtures', 'models.rb')
require File.join(File.dirname(__FILE__), 'fixtures', 'schema.rb')
require File.join(File.dirname(__FILE__), 'fixtures', 'factories.rb')
