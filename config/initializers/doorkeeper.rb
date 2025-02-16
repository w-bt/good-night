Doorkeeper.configure do
  orm :active_record

  # Ensure authentication uses Auth model, not User
  resource_owner_authenticator do
    current_auth || warden.authenticate!(scope: :auth)
  end

  resource_owner_from_credentials do |_routes|
    auth = Auth.find_by(email: params[:email])
    if auth&.valid_for_authentication? { auth.valid_password?(params[:password]) }
      auth.user
    end
  end

  access_token_expires_in 2.hours
  use_refresh_token

  default_scopes :public
  optional_scopes :write, :update

  grant_flows %w[authorization_code client_credentials password]
end
