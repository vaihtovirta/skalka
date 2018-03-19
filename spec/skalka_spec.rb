RSpec.describe Skalka do
  it "has a version number" do
    expect(Skalka::VERSION).not_to be nil
  end

  describe ".call" do
    subject(:result) { described_class.call(json) }

    context "when resource has no relationships" do
      let(:json) { File.read("spec/fixtures/simple_example.json") }

      it "returns flat hash" do
        expect(result.keys).to eq(%i[data])
        expect(result[:data].keys).to eq(%i[id title body created_at updated_at])
      end
    end

    context "when resource has relationships" do
      let(:json) { File.read("spec/fixtures/example_with_relationships.json") }

      it "returns flat hash" do
        expect(result.keys).to eq(%i[data links meta])
        expect(result[:data].keys).to eq(%i[id title body created_at updated_at author comments])
        expect(result[:data][:author][:articles]).to eq([{ id: 1 }])
      end
    end
  end
end
