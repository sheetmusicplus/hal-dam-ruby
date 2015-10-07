require 'spec_helper'

RSpec.describe HalDms::NetHttpAdapter do
  subject { described_class.new(URI.parse('https://haldms.halleonard.com')) }

  it { is_expected.to respond_to(:http_verb) }
end
