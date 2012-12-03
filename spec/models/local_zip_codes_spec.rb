require 'spec_helper'

describe LocalZipCodes do

  describe "local?" do
    it "will return false for nil" do
      LocalZipCodes.local?(nil).should == false
    end

    it "will return false for a non-local zip" do
      LocalZipCodes.local?(12345).should == false
    end

    it "will return true for a local zip" do
      LocalZipCodes.local?(98499).should == true
    end

  end
end
