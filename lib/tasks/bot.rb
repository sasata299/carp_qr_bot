class Tasks::Bot

  @client = nil
  @conn = nil

  class << self
    def tweet
      setup

      response = JSON.parse @conn.get('/score_reports').body

      response['score_reports'].each do |score_report|
        tweet = Tweet.new(score_report)
        tweet_response = @client.update(tweet.status)
        if tweet_response && tweet_response.class == Twitter::Tweet
          @conn.put("/score_reports/#{tweet.data_id}")
        end
      end

      if response['result']
        @client.update("試合終了\n\n#{response['result']}")
        @conn.put("/result/#{response['game_date']}")
      end
    end

    private

    def setup
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['CONSUMER_KEY']
        config.consumer_secret     = ENV['CONSUMER_SECRET']
        config.access_token        = ENV['OAUTH_TOKEN']
        config.access_token_secret = ENV['OAUTH_TOKEN_SECRET']
      end

      @conn = Faraday.new(:url => 'http://localhost:3000') do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end
  end
end
