require 'thread'

require 'async/notification'

class Portage::ThreadPool
  # == Constants ============================================================

  SIZE_DEFAULT = 5
  
  # == Extensions ===========================================================
  
  # == Class Methods ========================================================
  
  # == Instance Methods =====================================================
  
  def initialize(size: nil)
    size ||= SIZE_DEFAULT

    @queue = Queue.new

    @threads = size.times.map do
      Thread.new do
        Thread.abort_on_exception = true
        
        while (proc = @queue.pop)
          proc.call
        end
      end
    end
  end

  def exec(&block)
    @queue << -> do
      block.call
    end
  end

  # Call #task inside the same reactor to define an Async::Task
  def async(task: nil, &block)
    task ||= Async::Task.current

    notification = Portage::Notification.new

    @queue << -> do
      result = begin
        block.call

      rescue => e
        e
      end

      notification.signal(result, task: task)
      task.reactor.wakeup
    end

    notification
  end

  def wait
    @threads.count.times do
      @queue << nil
    end

    @threads.each(&:join)
  end
end
