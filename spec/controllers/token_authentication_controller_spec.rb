require 'rails_helper'

RSpec.describe TokenAuthenticationController, :type => :controller do

  describe "GET sign_in" do
    it "redirect to dashboard" do

      # registering at first...
      provider = "facebook"
      uid = "123"
      email = "my@email.com"
      user = User.social_authentication(provider, uid, email)

      # authenticating with token
      token = 'CAACEdEose0cBAJuj2ZAUHS9YQ6az4iySWAHFjXQTGOBjG9BfjKO58vZAD8VTdY9eu03DxKM6oRepCqKxqLI0qqUfpsFRL2uJEDul3Yrk9W1nEM4UiLll2VAY5ocvcBkHYntJdrNmQ2YfChpfNDErXDwCvBZAM1W8UDZA7hQWMaAVEpLquiek3zCoqE2ElWKcUzpFN5JuWtZBhucayFXfTJjzzHkzyBfkZD'
      email = "my@email.com"


      get :authenticate, { :format => :json, :provider=> provider, :token => token, :email => '' }
      expect(response).to have_http_status(:success)
      #expect(response).to redirect_to(dashboard_index_path)
      #expect(JSON.parse(response.body).length).to eq(3)
      expect(JSON.parse(response.body)["status"]).to eq("ok")

    end
  end

end
