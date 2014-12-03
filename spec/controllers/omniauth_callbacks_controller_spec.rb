require 'rails_helper'


RSpec.describe Users::OmniauthCallbacksController, :type => :controller do


  describe "blabla" do
    it "blabla" do
      get :facebook
      expect(response).to render_template("facebook")
    end
  end


end
