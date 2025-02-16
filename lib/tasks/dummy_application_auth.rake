namespace :doorkeeper do
  desc "Generate a new application with uid and secret"
  task generate_application: :environment do
    app = Doorkeeper::Application.create!(
      name: "Good Night",
      redirect_uri: "urn:ietf:wg:oauth:2.0:oob",
      uid: "7f439566-f7a8-49ae-b411-f55be71ab383",
      secret: "4965f800eb025d436a9cbfa2e2830ad730d9c652be9dd001b49ce7df56a08147"
    )
    puts "Application created with UID: #{app.uid} and Secret: #{app.secret}"
  end
end

namespace :auth do
  desc "Generate a dummy Auth record"
  task dummy: :environment do
    auth = Auth.create!(
      email: "admin@goodnight.com",
      password: "password",
      password_confirmation: "password"
    )
    puts "Dummy Auth record created with email: #{auth.email}"
  end
end
