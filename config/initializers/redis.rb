uri = URI.parse(Rails.configuration.redis_uri)
REDIS_URI = uri
REDIS = Redis.new(host: uri.host, port: uri.port, password: uri.password)

