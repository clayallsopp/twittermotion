class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    @window.rootViewController = UIViewController.alloc.initWithNibName(nil, bundle:nil)
    @window.makeKeyAndVisible

    Dispatch::Queue.main.async do
      Twitter.sign_in do |granted, error|

        if granted
          account = Twitter.accounts[0]
          account.compose(tweet: "Hello World!", urls: ["http://clayallsopp.com"]) do |composer|
            p "Done? #{composer.done?}"
            p "Cancelled? #{composer.cancelled?}"
            p "Error #{composer.error.inspect}"
          end
        end
      end
    end
    true
  end
end
