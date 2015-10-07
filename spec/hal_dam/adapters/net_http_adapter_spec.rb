require 'spec_helper'

RSpec.describe HalDam::NetHttpAdapter do
  subject { described_class.new(URI.parse('https://HalDam.halleonard.com')) }

  it { is_expected.to respond_to(:http_verb) }
end
