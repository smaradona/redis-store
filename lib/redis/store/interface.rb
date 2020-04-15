class Redis
  class Store < self
    module Interface
      def get(key, options = nil)
        puts "Get interface: key: #{key}"
        begin
          boop
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
        end
        super(key)
      end

      def set(key, value, options = nil)
        puts "Set interface: key: #{key}, value: #{value}"
        begin
          boop
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
        end
        super(key, value, options || {})
      end

      def setnx(key, value, options = nil)
        puts "setnx interface: key: #{key}, value: #{value}"
        begin
          boop
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
        end
        super(key, value)
      end

      def setex(key, expiry, value, options = nil)
        puts "setex interface: key: #{key}, value: #{value}"
        begin
          boop
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
        end
        super(key, expiry, value)
      end
    end
  end
end
