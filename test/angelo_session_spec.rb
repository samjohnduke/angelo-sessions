require_relative './spec_helper'

describe Angelo::Sessions do

  describe "Works when sessions installed" do

    define_app do
      include Angelo::Sessions

      session_config :secret_token => 'WB8hc93bz6MIsy2HdW5xA4vJ446Ww1ib'

      Angelo::HTTPABLE.each do |m|
        __send__ m, '/' do
          m.to_s
        end
      end
    end

    it 'responds to http requests properly' do
      Angelo::HTTPABLE.each do |m|
        __send__ m, '/'
        last_response_must_be_html m.to_s
      end
    end

  end

  describe "Works with sessions" do

    define_app do
      include Angelo::Sessions

      session_config :secret_token => 'WB8hc93bz6MIsy2HdW5xA4vJ446Ww1ib'

      get "/session" do
        session[:some_var] = "cookies"
      end

      get "/has_session" do
        session[:another_var]
      end

      get '/set_session' do
        session[:another_var] = "cookies are awesome"
      end

    end

    it "should set a cookie" do
      get '/session'
      last_response.headers["Set-Cookie"].wont_be_nil
    end

    it "should load a past session" do
      get '/set_session'
      cookie = last_response.headers["Set-Cookie"].split(";").first

      get '/has_session', {}, {'Cookie' => cookie}
      last_response.status.must_equal 200
    end

    it "should handle a non existant cookie" do
      get '/has_session', {}, {'Cookie' => "angelo-session=1234"}
      last_response.status.must_equal 200
    end

    it "should set a session var" do
      get '/set_session'
      cookie = last_response.headers["Set-Cookie"].split(";").first

      get '/has_session', {}, {'Cookie' => cookie}
      last_response.body.must_equal 'cookies are awesome'
    end

  end

end
