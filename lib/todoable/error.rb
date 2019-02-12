module Todoable
  # Error Classes for interacting with  the Todoable API
  class Error < StandardError
  end
  class ValidationError < Error; end
  class NotAuthenticatedError < Error; end
  class NotFoundError < Error; end
end