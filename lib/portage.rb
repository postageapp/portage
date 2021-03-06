require 'portage/version'

module Portage
  # == Constants ============================================================
  
  # == Module Methods =======================================================
  
end

require_relative 'portage/bridge'
require_relative 'portage/extensions'
require_relative 'portage/notification'
require_relative 'portage/thread_pool'
require_relative 'portage/thread_task'

require 'async'

Async::Reactor.include(Portage::Extensions::Reactor)
