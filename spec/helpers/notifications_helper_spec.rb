require "rails_helper"

RSpec.describe NotificationsHelper do
<<<<<<< HEAD
  context "when feature flag enabled" do
    before { allow(FeatureFlag).to receive(:enabled?).with(:multiple_reactions).and_return(true) }

    it "returns a new category image from ReactionCategory" do
      expect(helper.reaction_image("unicorn")).to eq("multi-unicorn.svg")
    end

    it "returns a heart for unrecognized category" do
      expect(helper.reaction_image("asdf")).to eq("sparkle-heart.svg")
    end
  end

  context "when feature flag disabled" do
    before { allow(FeatureFlag).to receive(:enabled?).with(:multiple_reactions).and_return(false) }

    it "returns an original category image from REACTION_IMAGES" do
      expect(helper.reaction_image("unicorn")).to eq("unicorn-filled.svg")
    end

    it "returns a heart for unrecognized category" do
      expect(helper.reaction_image("asdf")).to eq("heart-filled.svg")
=======
  it "returns a new category image from ReactionCategory" do
    expect(helper.reaction_image("unicorn")).to eq("multi-unicorn.svg")
  end

  it "returns a heart for unrecognized category" do
    expect(helper.reaction_image("asdf")).to eq("sparkle-heart.svg")
  end

  context "with a moderation notification" do
    let(:staff_account) do
      {
        "id" => 1,
        "name" => "Alice",
        "path" => "/alice123",
        "username" => "alice123"
      }
    end
    let(:new_user) do
      {
        "id" => 2,
        "name" => "Bob",
        "path" => "/the_builder",
        "username" => "the_builder"
      }
    end
    let(:comment) do
      {
        "id" => 30,
        "path" => "/#{new_user['username']}/comment/10"
      }
    end

    it "returns the commenting user's name and profile path if the user is included" do
      data = {
        "user" => staff_account,
        "comment" => comment,
        "comment_user" => new_user
      }

      expect(helper.mod_comment_user(data)).to include({ "name" => "Bob", "path" => "/the_builder" })
    end

    it "extracts the commenting user's username and path from the comment if the user is not included" do
      data = {
        "user" => staff_account,
        "comment" => comment
      }

      expect(helper.mod_comment_user(data)).to include({ "name" => "the_builder", "path" => "/the_builder" })
>>>>>>> upstream/main
    end
  end
end
