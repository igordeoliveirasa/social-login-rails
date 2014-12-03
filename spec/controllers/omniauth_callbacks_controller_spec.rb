require 'rails_helper'


RSpec.describe Users::OmniauthCallbacksController, :type => :controller do


  before do

    request.env["devise.mapping"] = Devise.mappings[:user]
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
                                                                      :provider => 'facebook',
                                                                      :uid => '123545',
                                                                      :info => {
                                                                          :email => 'igordeoliveirasa@gmail.com',
                                                                          :name => '',
                                                                          :image => '',
                                                                      },
                                                                  })

    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]

  end


  describe "blabla" do
    it "blabla" do
      get :facebook
      expect(response).to redirect_to("/dashboard/index")
    end
  end


end
