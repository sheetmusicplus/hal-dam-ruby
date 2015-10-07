require 'spec_helper'

RSpec.describe HalDam::Client do
  subject { described_class.new('vendor_id', 'vendor_key') }

  it { is_expected.to be_kind_of(HalDam::ApiClient) }

  it 'responds to endpoints' do
    endpoints.each do |ref|
      is_expected.to respond_to(ref)
    end
  end

  describe '#medatdata' do
    let(:start_date) { Date.today - 7 }
    let(:stop_date) { Date.today }

    it 'returns a <DAMResponse/>' do
      stub_request(:post, 'https://HalDam.halleonard.com/dam').to_return(body: '<DAMResponse/>')
      subject.metadata(start_date, stop_date) do |resp|
        expect(resp).to eq('<DAMResponse/>')
      end
    end
  end

  private

  def endpoints
    %w(metadata)
  end
end
