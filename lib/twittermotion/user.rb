module Twitter
  class User
    attr_accessor :ac_account

    def initialize(ac_account)
      self.ac_account = ac_account
    end

    def username
      self.ac_account.username
    end

    # user.compose(tweet: 'initial tweet', images: [ui_image, ui_image],
    #   urls: ["http://", ns_url, ...]) do |composer|
    #
    # end
    def compose(options = {}, &block)
      @composer = Twitter::Composer.new
      @composer.compose(options) do |composer|
        block.call(composer)
      end
    end

    # user.get_timeline(include_entities: 1) do |hash, ns_error|
    # end
    def get_timeline(options = {}, &block)
      url = NSURL.URLWithString("http://api.twitter.com/1/statuses/home_timeline.json")
      request = TWRequest.alloc.initWithURL(url, parameters:options, requestMethod:TWRequestMethodGET)
      request.account = self.ac_account
      request.performRequestWithHandler(lambda {|response_data, url_response, error|
        if !response_data
          block.call(nil, error)
        else
          block.call(BubbleWrap::JSON.parse(response_data), nil)
        end
      })
    end
  end
end