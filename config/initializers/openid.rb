module Rack
  class OpenID
    
    def call(env)
      req = Rack::Request.new(env)
      
      reurldecode req, 'openid.ns'
      reurldecode req, 'openid.op_endpoint'
      reurldecode req, 'openid.claimed_id'
      reurldecode req, 'openid1_claimed_id'
      reurldecode req, 'openid.response_nonce'
      reurldecode req, 'openid.identity'
      reurldecode req, 'openid.return_to'
      reurldecode req, 'openid.signed'
      reurldecode req, 'openid.sig'
      reurldecode req, 'rp_nonce'

      if req.params["openid.mode"]
        complete_authentication(req, env)
      end

      status, headers, body = @app.call(env)

      qs = headers[AUTHENTICATE_HEADER]
      if status.to_i == 401 && qs && qs.match(AUTHENTICATE_REGEXP)
        begin_authentication(env, qs)
      else
        [status, headers, body]
      end
    end

    def complete_authentication(req, env)
      session = env["rack.session"]

      unless session
        raise RuntimeError, "Rack::OpenID requires a session"
      end

      oidresp = timeout_protection_from_identity_server {
        consumer = ::OpenID::Consumer.new(session, @store)
        consumer.complete(flatten_params(req.params), req.url)
      }

      env[RESPONSE] = oidresp

      method = req.GET["_method"]
      override_request_method(env, method)

      sanitize_query_string(env)
    end

    def reurldecode(request, key)
      request.update_param key, URI.unescape(request.params[key]) if request.params[key] && request.params[key].include?('%')
    end
  end
end
