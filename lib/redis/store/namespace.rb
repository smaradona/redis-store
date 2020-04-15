class Redis
  class Store < self
    module Namespace
      FLUSHDB_BATCH_SIZE = 1000

      def set(key, val, options = nil)
        puts "Set: key: #{key}, val: #{val}"
        begin
          boop
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
        end
        namespace(key) { |k| super(k, val, options) }
      end

      def setex(key, ttl, val, options = nil)
        puts "Setex: key: #{key}, val: #{val}"
        begin
          boop
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
        end
        namespace(key) { |k| super(k, ttl, val, options) }
      end

      def setnx(key, val, options = nil)
        puts "Setnx: key: #{key}, val: #{val}"
        begin
          boop
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
        end
        namespace(key) { |k| super(k, val, options) }
      end

      def ttl(key, options = nil)
        puts "ttl: key: #{key}"
        begin
          boop
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
        end
        namespace(key) { |k| super(k) }
      end

      def get(key, options = nil)
        puts "get: key: #{key}"
        begin
          boop
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
        end
        namespace(key) { |k| super(k, options) }
      end

      def exists(key)
        puts "exists: key: #{key}"
        begin
          boop
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
        end
        namespace(key) { |k| super(k) }
      end

      def incrby(key, increment)
        puts "incrby: key: #{key}"
        begin
          boop
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
        end
        namespace(key) { |k| super(k, increment) }
      end

      def decrby(key, increment)
        puts "decrby: key: #{key}"
        begin
          boop
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
        end
        namespace(key) { |k| super(k, increment) }
      end

      def keys(pattern = "*")
        puts "keys: pattern: #{pattern}"
        begin
          boop
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
        end
        namespace(pattern) { |p| super(p).map{|key| strip_namespace(key) } }
      end

      def del(*keys)
        puts "Deleting: keys: #{keys}"
        begin
          boop
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
        end

        super(*keys.map {|key| interpolate(key) }) if keys.any?
      end

      def watch(*keys)
        puts "watch: keys: #{keys}"
        begin
          boop
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
        end
        super(*keys.map {|key| interpolate(key) }) if keys.any?
      end

      def mget(*keys)
        puts "mget: keys: #{keys}"
        begin
          boop
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
        end
        options = (keys.pop if keys.last.is_a? Hash) || {}
        if keys.any?
          # Serialization gets extended before Namespace does, so we need to pass options further
          if singleton_class.ancestors.include? Serialization
            super(*keys.map {|key| interpolate(key) }, options)
          else
            super(*keys.map {|key| interpolate(key) })
          end
        end
      end

      def expire(key, ttl)
        puts "expire: key: #{key}"
        begin
          boop
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
        end
        namespace(key) { |k| super(k, ttl) }
      end

      def to_s
        if namespace_str
          "#{super} with namespace #{namespace_str}"
        else
          super
        end
      end

      def flushdb
        puts "flushdb"
        begin
          boop
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
        end
        keys.each_slice(FLUSHDB_BATCH_SIZE) { |key_slice| del(*key_slice) }
      end

      def with_namespace(ns)
        old_ns = @namespace
        @namespace = ns
        yield self
      ensure
        @namespace = old_ns
      end

      private
        def namespace(key)
          yield interpolate(key)
        end

        def namespace_str
          @namespace.is_a?(Proc) ? @namespace.call : @namespace
        end

        def interpolate(key)
          return key unless namespace_str
          key.match(namespace_regexp) ? key : "#{namespace_str}:#{key}"
        end

        def strip_namespace(key)
          return key unless namespace_str
          key.gsub namespace_regexp, ""
        end

        def namespace_regexp
          @namespace_regexps ||= {}
          @namespace_regexps[namespace_str] ||= %r{^#{namespace_str}\:}
        end
    end
  end
end
