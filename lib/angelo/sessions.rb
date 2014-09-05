require "angelo/sessions/version"
require "angelo/sessions/"
module Angelo
  module Sessions

    def self.included base
      base.extend ClassMethods

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
        secret_token    = opts[:secret_token]   ? opts[:secret_token]   : ''
        session_store   = opts[:session_store]  ? opts[:session_store]  : 'Angelo::Sessions::LocalStore'
        session_length  = opts[:session_length] ? opts[:session_length] : 43200           # Defaults to 12 hours
        session_name    = opts[:session_name]   ? opts[:session_name]   : 'angelo-sessions'

        Angelo::Sessions::store = Object.const_get(session_store).new(secret_token, session_length, session_name)
      end

    end

    def self.registered app

      # DOES NOT WORK YET

      # app.before do 
      #   init_session request
      # end

      # app.after do 
      #   finalize_session
      # end
    end

    def self.store
      @@store ||= nil
    end

    def self.store= store
      @@store = store
    end

    def init_session request
      @session ||= Bag.new Angelo::Sessions::store, request
    end

    def session 
      @session
    end

    def finalize_session
      key = @session.save
      if key
        headers "Set-Cookie" => "#{Angelo::Sessions::store.name}=#{key}; max-age=#{Angelo::Sessions::store.length}; Path=/; HttpOnly"
      end
    end

  end
end
