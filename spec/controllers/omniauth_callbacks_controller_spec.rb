require 'rails_helper'


RSpec.describe OmniauthCallbacksController, :type => :controller do

  it "render facebook" do
    get :facebook
    expect(response).to render_template("facebook")
  end

end
