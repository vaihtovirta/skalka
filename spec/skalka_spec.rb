RSpec.describe Skalka do
  it "has a version number" do
    expect(Skalka::VERSION).not_to be nil
  end

  describe ".call" do
    subject(:result) { described_class.call(json) }
    let(:first_resource) { result[:data].first }

    context "when resource has no relationships" do
      let(:json) { File.read("spec/fixtures/simple.json") }

      it "returns flat hash" do
        expect(result.keys).to eq(%i[data])
        expect(first_resource.keys).to eq(%i[id title body created_at updated_at])
      end
    end

    context "when resource has relationships" do
      let(:json) { File.read("spec/fixtures/with_relationships.json") }

      it "returns flat hash" do
        expect(result.keys).to eq(%i[data links meta])
        expect(first_resource.keys).to eq(%i[id title body created_at updated_at author comments])
        expect(first_resource[:author][:articles]).to eq([{ id: 1 }])
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

      it "returns flat hash" do
        expect(result.keys).to eq(%i[data])
        expect(resource.keys).to eq(resource_keys)
        expect(resource[:favored][:bank].keys)
          .to eq(%i[id title code document status site created_at updated_at active short_name ispb])
      end
    end
  end
end
