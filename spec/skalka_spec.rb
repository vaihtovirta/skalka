RSpec.describe Skalka do
  it "has a version number" do
    expect(Skalka::VERSION).not_to be nil
  end

  describe ".call" do
    subject(:result) { described_class.call(json) }
    let(:first_resource) { result[:data].first }
    let(:attributes) { first_resource[:attributes] }

    context "when json is nil" do
      let(:json) { nil }

      it "returns empty data" do
        expect { result }.to raise_error(described_class::NullJsonError, "JSON is nil")
      end
    end

    context "when json is empty" do
      let(:json) { "{}" }

      it "returns empty data" do
        expect(result.keys).to eq(%i[data])
      end
    end

    context "when resource has no relationships" do
      let(:json) { File.read("spec/fixtures/simple.json") }

      it "returns parsed hash" do
        expect(result.keys).to eq(%i[data])
        expect(first_resource.keys).to eq(%i[id type attributes])
        expect(attributes.keys).to eq(%i[title body created_at updated_at])
      end
    end

    context "when resource has relationships" do
      let(:json) { File.read("spec/fixtures/with_relationships.json") }
      let(:author) { attributes.dig(:author) }
      let(:author_articles) { attributes.dig(:author, :attributes, :articles) }
      let(:comment) { attributes.dig(:comments, 0, :attributes) }

      it "returns parsed hash" do
        expect(result.keys).to eq(%i[data links meta])
        expect(first_resource.keys).to eq(%i[id type attributes])
        expect(attributes.keys).to eq(%i[title body created_at updated_at author comments])
        expect(author.keys).to eq(%i[id type attributes])
        expect(author_articles).to eq([{ id: "1" }])
        expect(comment).to eq(content: "Ok")
      end
    end

    context "when resource has complex structure" do
      let(:json) { File.read("spec/fixtures/complex.json") }
      let(:resource) { result[:data] }
      let(:resource_keys) do
        %i[
          id user-id type status cancel-reason reverse-reason auth-code date value agency account updated-at
          created-at scheduled-at ticketed-at canceled-at late-at done-at cops-updated-at cops-user reversed-at
          ticket-auth-code ticket-cancel-reason errors scheduled? schedulable? waiting? done? canceled?
          ticketed? late? prewaiting? reversed? display-amount financial-institution-id liquidated? liquidatable?
          reviewable? created-by confirmed-by canceled-by scheduled-by reversed-by cancelable-by-user?
          cancelable-by-manager? transfer-reason-id favored transfer-reason
        ]
      end
      let(:nested_resource) do
        resource.dig(:attributes, :favored, :attributes, :bank)
      end

      it "returns parsed hash" do
        expect(result.keys).to eq(%i[data])
        expect(resource.keys).to eq(%i[id type attributes])
        expect(nested_resource.keys)
          .to eq(%i[id title code document status site created_at updated_at active short_name ispb])
      end
    end
  end
end
