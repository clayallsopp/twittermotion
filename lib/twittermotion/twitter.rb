module Twitter
  module_function
  def account_store
    @account_store ||= ACAccountStore.new
  end

  def account_type
    @account_type ||= self.account_store.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
  end

  def accounts
    @accounts ||= self.account_store.accountsWithAccountType(account_type).collect do |ac_account|
      Twitter::User.new(ac_account)
    end
  end

  def sign_in(&block)
    @sign_in_callback = block
    self.account_store.requestAccessToAccountsWithType(self.account_type,
        withCompletionHandler:lambda { |granted, error|
      # Reset accounts
      @accounts = nil
      Dispatch::Queue.main.sync {
        @sign_in_callback.call(granted, error)
      }
    })
  end
end