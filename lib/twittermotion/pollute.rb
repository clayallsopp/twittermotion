class ACAccountType
  alias_method :granted?, :accessGranted
  alias_method :description, :accountTypeDescription
end

class ACAccount
  alias_method :account_description, :accountDescription
  alias_method :account_type, :accountType
end