require 'time'

require "angelo/sessions/version"
require "angelo/sessions/store"
require "angelo/sessions/store/local"
require "angelo/sessions/bag"

module Angelo
  module Sessions
    extend Celluloid::Logger

    COOKIE_KEY = 'Cookie'
    SET_COOKIE_KEY = 'Set-Cookie'
    COOKIE = '%s=%s; Expires=%s; Path=/; HttpOnly'

    DEFAULT_SESSION_CONFIG = {
      secret_token: '',
      session_store: Angelo::Sessions::LocalStore,
      session_length: 43200, # 12 hours
      session_name: 'angelo_sessions'
    }

    def self.included base
      base.extend ClassMethods
      info "Angelo sessions #{Angelo::Sessions::VERSION}"

      registered(base)
    end

    module ClassMethods

      # Configure that session by overiding defaults such as encryption key, Store Type
      # session length and more
      #
      # Example
      # -------
      # session_config({
      #  secret_token: "3WDcOwq9rUQPGyjbL1YcF67Dv0OC6x16",
      #  session_store: "Cookie"
      #  session_length: ""
      #  session_name: ""
      # })
      #
      # params opts Array
      # params opts[:secret_token] any 256 bit key
      # params opts[:session_store] any of Redis or [User defined]
      # params opts[:session_length] any seconds until expiry
      # params opts[:session_name] any string name
      #
      def session_config opts={}
        opts = DEFAULT_SESSION_CONFIG.merge opts
        store = opts[:session_store].new opts[:secret_token],
                                         opts[:session_length],
                                         opts[:session_name]
        raise 'no store configured' unless store
        Angelo::Sessions.store = store
      end

    end

    def self.registered app
      app.before do
        init_session request
      end

      app.after do
        finalize_session
      end
    end

    def self.store
      @@store ||= nil
    end

    def self.store= store
      @@store = store
    end

    def init_session request
      @session ||= Bag.new Angelo::Sessions.store, request
    end

    def session
      @session
    end

    def finalize_session
      key = @session.save
      set_response_header key if key
    end

    def set_response_header key
      headers SET_COOKIE_KEY => COOKIE % [Angelo::Sessions.store.name, key, Angelo::Sessions.store.expires]
    end

  end
end
