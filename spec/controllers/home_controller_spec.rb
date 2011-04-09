# http://relishapp.com/rspec/rspec-rails/v/2-5/dir/view-specs/view-spec
require 'spec_helper'

describe HomeController do
  let(:user) { User.new }

  describe "#what_we_do" do
    it "should return status 200" do
      get :what_we_do
      response.status.should be(200)
    end

    it "should render what_we_do template" do
      get :what_we_do
      response.should render_template("home/what_we_do")
    end
  end
end
