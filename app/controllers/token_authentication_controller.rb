class TokenAuthenticationController < ApplicationController
  respond_to :json
  skip_before_action :verify_authenticity_token
  include Devise::Controllers::Helpers

  def authenticate
    msg = { :status => "fail", :message => "Fail!" }

    provider = params["provider"]
    token = params["token"]
    email = params["email"]

    begin

      graph_user = FbGraph::User.me(token)
      graph_user = graph_user.fetch

      if graph_user

        uid = graph_user.identifier

        user = User.social_authentication(provider, uid, email)
        unless user
          user = User.social_registration(provider, uid, email)
        end
        sign_in user

        msg = { :status => "ok", :message => "Success!", :user => user.as_json }
      end
    rescue Exception => exc
      msg[:message] = exc.message
    end

    respond_to do |format|
      format.json  { render :json => msg } # don't do msg.to_json
    end

  end
end
