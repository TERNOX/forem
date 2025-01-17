require "rails_helper"

RSpec.describe Badges::AwardTwoWeekStreak, type: :service do
  it "calls Badges::AwardStreak with argument 2" do
    allow(Badges::AwardStreak).to receive(:call)
    described_class.call
    expect(Badges::AwardStreak).to have_received(:call).with(weeks: 2)
  end
end
