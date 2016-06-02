require "rails_helper"

describe TextComponent, :type => :model do

  context "without a report" do
    specify { expect(build(:text_component, :report => nil)).not_to be_valid }
  end

end
