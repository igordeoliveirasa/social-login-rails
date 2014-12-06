class TokenAuthenticationController < ApplicationController
  include Devise::Controllers::Helpers
  def authenticate

    provider = params["provider"]
    token = params["token"]
    graph_user = FbGraph::User.me(token).fetch
    uid = graph_user.identifier

    user = User.social_authentication(provider, uid, nil)

    respond_to do |format|
      #msg = { :status => "ok", :message => "Success!", :html => "<b>...</b>" }
      msg = { :status => "fail", :message => "Fail!" }
      format.json  { render :json => msg } # don't do msg.to_json
    end

  end
end
