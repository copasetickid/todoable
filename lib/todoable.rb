require "httparty"
require 'dotenv'
require "todoable/version"
require "todoable/error"
require "todoable/client"
require "todoable/list"
require "todoable/item"

module Todoable
  #class Error < StandardError; end
  # Your code goes here...
  Dotenv.load
end
