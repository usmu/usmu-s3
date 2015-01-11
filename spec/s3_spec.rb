require 'usmu/s3'
require 'usmu/commander_mock'
require 'ostruct'

RSpec.describe Usmu::S3 do
  let(:plugin) { Usmu::S3.new }
  let(:commander) { Usmu::CommanderMock.new }

  context '#initialize' do
    it 'configures logging' do
      expect(plugin.send(:log).is_a? Logging::Logger).to eq(true)
      expect(plugin.send(:log).name).to eq(described_class.name)
    end

    it 'logs initialization' do
      plugin
      expect(@log_output.readline).to eq("DEBUG  Usmu::S3 : Initializing usmu-s3 v#{Usmu::S3::VERSION}\n")
    end
  end

  context '#commands' do
    let(:ui) { OpenStruct.new }

    it 'logs when commands are accessed' do
      plugin.commands(ui, commander)
      # Discard the line from initialization
      @log_output.readline
      expect(@log_output.readline).to eq("DEBUG  Usmu::S3 : Adding commands from usmu-s3.\n")
    end

    it 'preserves the UI for later usage' do
      plugin.commands(ui, commander)
      expect(plugin.send :ui).to eq(ui)
    end

    it 'creates an "s3 deploy" command' do
      plugin.commands(ui, commander)
      expect(commander.get_command(:'s3 deploy')[:syntax]).to eq('usmu s3 deploy')
      expect(commander.get_command(:'s3 deploy')[:description]).to eq('Deploys your website to S3')
      expect(commander.get_command(:'s3 deploy')[:action].arity).to eq(2)
    end
  end
end
