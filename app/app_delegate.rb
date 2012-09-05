class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @controller = UIViewController.alloc.initWithNibName(nil, bundle:nil)
    @window.rootViewController = @controller
    @window.makeKeyAndVisible

      Twitter.sign_in do |granted, error|
        if granted
          compose = UIButton.buttonWithType(UIButtonTypeRoundedRect)
          compose.setTitle("Compose", forState:UIControlStateNormal)
          compose.sizeToFit
          @controller.view.addSubview(compose)
          compose.when UIControlEventTouchUpInside do
            account = Twitter.accounts[0]
            account.compose(tweet: "Hello World!", urls: ["http://clayallsopp.com"]) do |composer|
              p "Done? #{composer.done?}"
              p "Cancelled? #{composer.cancelled?}"
              p "Error #{composer.error.inspect}"
            end
          end

          timeline = UIButton.buttonWithType(UIButtonTypeRoundedRect)
          timeline.setTitle("Timeline", forState:UIControlStateNormal)
          timeline.setTitle("Loading", forState:UIControlStateDisabled)
          timeline.sizeToFit
          timeline.frame = compose.frame.below(10)
          @controller.view.addSubview(timeline)
          timeline.when UIControlEventTouchUpInside do
            timeline.enabled = false
            account = Twitter.accounts[0]
            account.get_timeline do |hash, error|
              timeline.enabled = true
              p "Timeline #{hash}"
            end
          end
        else
          label = UILabel.alloc.initWithFrame(CGRectZero)
          label.text = "Denied :("
          label.sizeToFit
          label.center = @controller.view.frame.center
          @controller.view.addSubview(label)
        end
      end
    true
  end
end
