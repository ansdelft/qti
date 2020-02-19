describe Qti::V2::Models::Interactions::ExtendedTextInteraction do
  context 'essay.xml' do
    let(:item) { double(package_root: 'dummy', path: 'dummy/blah') }
    let(:io) { File.read(File.join('spec', 'fixtures', 'items_2.1', 'essay.xml')) }
    let(:node) { Nokogiri::XML(io).at_xpath('//xmlns:extendedTextInteraction') }

    let(:loaded_class) { described_class.new(node, item) }

    it 'returns shuffle setting' do
      expect(loaded_class.shuffled?).to eq false
    end

    it 'returns the expected lines' do
      expect(loaded_class.expected_lines).to eq 0
    end

    it 'returns the max choices count' do
      expect(loaded_class.max_strings).to eq 500
    end

    it 'returns the min strings' do
      expect(loaded_class.min_strings).to eq 1
    end
  end
end
