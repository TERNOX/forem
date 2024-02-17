require "rails_helper"

RSpec.describe ContentRenderer do
<<<<<<< HEAD
  describe "#process" do
    let(:markdown) { "hello, hey" }
    let(:expected_result) { "<p>hello, hey</p>\n\n" }
    let(:mock_fixer) { class_double MarkdownProcessor::Fixer::FixAll }
    let(:mock_front_matter_parser) { instance_double FrontMatterParser::Parser }
    let(:mock_processor) { class_double MarkdownProcessor::Parser }
    let(:fixed_markdown) { :fixed_markdown }
    let(:parsed_contents) { Struct.new(:content, :front_matter).new(:parsed_content) }
    let(:processed_contents) { instance_double MarkdownProcessor::Parser }

    # rubocop:disable RSpec/InstanceVariable
    before do
      allow(mock_fixer).to receive(:call).and_return(fixed_markdown)
      allow(mock_front_matter_parser).to receive(:call).with(fixed_markdown).and_return(parsed_contents)
      allow(mock_processor).to receive(:new).and_return(processed_contents)
      allow(processed_contents).to receive(:finalize).and_return(expected_result)
      @original_fixer = described_class.fixer
      @original_parser = described_class.front_matter_parser
      @original_processor = described_class.processor

      described_class.fixer = mock_fixer
      described_class.front_matter_parser = mock_front_matter_parser
      described_class.processor = mock_processor
    end

    after do
      described_class.fixer = @original_fixer
      described_class.front_matter_parser = @original_parser
      described_class.processor = @original_processor
    end
    # rubocop:enable RSpec/InstanceVariable

    it "is the result of fixing, parsing, and processing" do
      result = described_class.new(markdown, source: nil, user: nil).process
      expect(result).to eq(expected_result)
      expect(mock_fixer).to have_received(:call)
      expect(mock_front_matter_parser).to have_received(:call).with(fixed_markdown)
      expect(mock_processor).to have_received(:new)
      expect(processed_contents).to have_received(:finalize)
=======
  let(:markdown) { "hello, hey" }
  let(:renderer) { described_class.new(markdown, source: nil, user: nil, fixer: MarkdownProcessor::Fixer::FixAll) }

  it "calls fixer" do
    allow(MarkdownProcessor::Fixer::FixAll).to receive(:call).and_call_original
    described_class.new(markdown, source: nil, user: nil, fixer: MarkdownProcessor::Fixer::FixAll).process
    expect(MarkdownProcessor::Fixer::FixAll).to have_received(:call).with(markdown)
  end

  describe "#process" do
    let(:parser) { instance_double(MarkdownProcessor::Parser) }

    context "with double parser" do
      before do
        allow(MarkdownProcessor::Parser).to receive(:new).and_return(parser)
        allow(parser).to receive(:finalize)
        allow(parser).to receive(:calculate_reading_time).and_return(1)
      end

      it "calls finalize with link_attributes" do
        renderer.process(link_attributes: { rel: "nofollow" })
        finalize_attrs = {
          link_attributes: { rel: "nofollow" },
          prefix_images_options: { width: 800, synchronous_detail_detection: false }
        }
        expect(parser).to have_received(:finalize).with(finalize_attrs)
      end
    end
  end

  describe "#process_article" do
    it "calculates reading time if processing an article" do
      result = renderer.process_article
      expect(result.reading_time).to eq(1)
    end

    it "sets front_matter if it exists" do
      frontmatter_markdown = <<~HEREDOC
        ---
        title: Hello
        published: false
        description: Hello Hello
        ---
        lalalalala
      HEREDOC
      md_renderer = described_class.new(frontmatter_markdown, source: nil, user: nil,
                                                              fixer: MarkdownProcessor::Fixer::FixAll)
      result = md_renderer.process_article
      expect(result.front_matter["title"]).to eq("Hello")
      expect(result.front_matter["description"]).to eq("Hello Hello")
>>>>>>> upstream/main
    end
  end

  context "when markdown is valid" do
<<<<<<< HEAD
    let(:markdown) { "# Hey\n\nHi, hello there, what's up?" }
    let(:expected_result) { <<~RESULT }
      <h1>
        <a name="hey" href="#hey">
        </a>
        Hey
      </h1>

      <p>Hi, hello there, what's up?</p>

    RESULT

    it "processes markdown" do
      result = described_class.new(markdown, source: nil, user: nil).process
      expect(result).to eq(expected_result)
    end
  end

  context "when markdown has liquid tags that aren't allowed for user" do
    let(:markdown) { "hello hey hey hey {% poll 123 %}" }
    let(:article) { build(:article) }
    let(:user) { instance_double(User) }

    before do
      allow(user).to receive(:any_admin?).and_return(false)
    end

    it "raises ContentParsingError" do
      expect do
        described_class.new(markdown, source: article, user: user).process
      end.to raise_error(ContentRenderer::ContentParsingError, /User is not permitted to use this liquid tag/)
    end
  end

  context "when markdown has liquid tags that aren't allowed for source" do
    let(:markdown) { "hello hey hey hey {% poll 123 %}" }
    let(:source) { build(:comment) }
=======
    let(:markdown) { "# Hey\n\nI'm a markdown" }
    let(:expected_result) do
      "<h1>\n  <a name=\"hey\" href=\"#hey\">\n  </a>\n  Hey\n</h1>\n\n<p>I'm a markdown</p>\n\n"
    end

    it "processes markdown" do
      result = described_class.new(markdown, source: build(:comment), user: build(:user)).process
      expect(result.processed_html).to eq(expected_result)
    end
  end

  context "when markdown contains an invalid liquid tag" do
    let(:markdown) { "hello hey hey hey {% gist 123 %}" }
>>>>>>> upstream/main
    let(:user) { instance_double(User) }

    before do
      allow(user).to receive(:any_admin?).and_return(true)
    end

<<<<<<< HEAD
    it "raises ContentParsingError" do
=======
    it "raises ContentParsingError for comment" do
      source = build(:comment)
      expect do
        described_class.new(markdown, source: source, user: user).process
      end.to raise_error(ContentRenderer::ContentParsingError, /Invalid Gist link: 123 Links must follow this format/)
    end
  end

  context "when markdown has liquid tags that aren't allowed for source" do
    let(:markdown) { "hello hey hey hey {% poll 123 %}" }
    let(:user) { instance_double(User) }

    before do
      allow(user).to receive(:any_admin?).and_return(true)
    end

    it "raises ContentParsingError for comment" do
      source = build(:comment)
      expect do
        described_class.new(markdown, source: source, user: user).process
      end.to raise_error(ContentRenderer::ContentParsingError, /This liquid tag can only be used in Articles/)
    end

    it "raises ContentParsingError for billboard" do
      source = build(:billboard)
>>>>>>> upstream/main
      expect do
        described_class.new(markdown, source: source, user: user).process
      end.to raise_error(ContentRenderer::ContentParsingError, /This liquid tag can only be used in Articles/)
    end
  end

  context "when markdown has invalid frontmatter" do
    let(:markdown) { "---\ntitle: Title\npublished: false\npublished_at:2022-12-05 18:00 +0300---\n\n" }

    it "raises ContentParsingError" do
      expect do
<<<<<<< HEAD
        described_class.new(markdown, source: nil, user: nil).process
=======
        described_class.new(markdown, source: nil, user: nil).process_article
>>>>>>> upstream/main
      end.to raise_error(ContentRenderer::ContentParsingError, /while scanning a simple key/)
    end
  end
end
