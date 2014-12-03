require 'rails_helper'

# confira o do Akita: https://github.com/cidadedemocratica/cidadedemocratica/blob/master/spec/controllers/omniauth_callbacks_controller_spec.rb

RSpec.describe Users::OmniauthCallbacksController, :type => :controller do

  describe "login" do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
                                                                        :provider => 'facebook',
                                                                        :uid => '123545',
                                                                        :info => { :email => 'igordeoliveirasa@gmail.com',  :name => '', },
                                                                    })

      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
      get :facebook
    end

    it { should be_user_signed_in }
    it { expect(response).to redirect_to(dashboard_index_path) }
  end

  describe "do not login unregistered authorization" do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
                                                                        :provider => 'facebook',
                                                                        :uid => '123545',
                                                                        :info => { :name => '', },
                                                                    })
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
      get :facebook
    end

    it { should_not be_user_signed_in }
    it { expect(response).to redirect_to(new_user_registration_path) }

  end

end
