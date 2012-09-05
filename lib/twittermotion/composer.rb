module Twitter
  class ComposerError
    attr_accessor :invalid_tweet
    attr_accessor :invalid_images
    attr_accessor :invalid_urls

    def initialize(tweet = nil, images = nil, urls = nil)
      self.invalid_tweet = tweet
      self.invalid_images = images
      self.invalid_urls = urls
    end
  end

  class Composer
    def self.available?
      TWTweetComposeViewController.canSendTweet
    end

    attr_accessor :compose_controller
    attr_accessor :callback
    attr_accessor :error, :result
    attr_accessor :images, :urls, :tweet

    def compose_controller
      @compose_controller ||= TWTweetComposeViewController.new
    end

    def done?
      @result == TWTweetComposeViewControllerResultDone
    end

    def cancelled?
      @result == TWTweetComposeViewControllerResultCancelled
    end

    def urls=(urls)
      self.compose_controller.removeAllURLs

      invalid_urls = []
      urls ||= []

      urls.each do |url|
        _url = url
        if _url.is_a? NSString
          _url = NSURL.URLWithString(url)
        end
        if !self.compose_controller.addURL(_url)
          invalid_urls << url
        end
      end

      if invalid_urls.length > 0
        self.error ||= Twitter::ComposerError.new
        self.error.invalid_urls = invalid_urls
      end

      @urls = urls
    end

    def images=(images)
      self.compose_controller.removeAllImages

      invalid_images = []
      images ||= []
      images.each do |ui_image|
        if !self.compose_controller.addImage(ui_image)
          invalid_images << ui_image
        end
      end

      if invalid_images.length > 0
        self.error ||= Twitter::ComposerError.new
        self.error.invalid_images = invalid_images
      end

      @images = images
    end

    def tweet=(tweet)
      if !self.compose_controller.setInitialText(tweet)
        self.error ||= Twitter::ComposerError.new
        self.error.invalid_tweet = tweet
      end

      @tweet = tweet
    end

    def compose(options = {}, &compose_callback)
      self.error = nil

      self.tweet = options[:tweet] || self.tweet
      self.images = options[:images] || self.images
      self.urls = options[:urls] || self.urls

      if self.error
        Dispatch::Queue.main.async {
          compose_callback.call(self)
        }
        return
      end

      options[:animated] = true if !options.has_key? :animated
      options[:presenting_controller] ||= UIWindow.keyWindow.rootViewController

      self.callback ||= lambda { |composer|
        self.compose_controller.dismissModalViewControllerAnimated(true)
        compose_callback.call(self)
      }
      self.compose_controller.completionHandler = lambda { |result|
        self.result = result
        self.callback.call(self)
      }

      options[:presenting_controller].presentModalViewController(self.compose_controller, animated: options[:animated])
    end
  end
end