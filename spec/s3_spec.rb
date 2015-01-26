require 'usmu/s3'
require 'usmu/configuration'
require 'usmu/uploader_mock'
require 'usmu/commander_mock'
require 'ostruct'
require 'commander'

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
      expect(@log_output.readline).to eq("  DEBUG  Usmu::S3 : Initializing usmu-s3 v#{Usmu::S3::VERSION}\n")
    end
  end

  context '#commands' do
    let(:ui) { OpenStruct.new }

    it 'logs when commands are accessed' do
      plugin.commands(ui, commander)
      # Discard the line from initialization
      @log_output.readline
      expect(@log_output.readline).to eq("  DEBUG  Usmu::S3 : Adding commands from usmu-s3.\n")
    end

    it 'preserves the UI for later usage' do
      plugin.commands(ui, commander)
      expect(plugin.send :ui).to eq(ui)
    end

    it 'creates an "s3 deploy" command' do
      plugin.commands(ui, commander)
      expect(commander.get_command(:'s3 deploy')[:syntax]).to eq('usmu s3 deploy')
      expect(commander.get_command(:'s3 deploy')[:description]).to eq('Deploys your website to S3')
      expect(commander.get_command(:'s3 deploy')[:action]).to be_a(Proc)
    end
  end

  context '#command_deploy' do
    let(:empty_configuration) { Usmu::Configuration.from_hash({}) }
    let(:configuration) {
      Usmu::Configuration.from_hash(
          {
              'plugin' => {
                  's3' => {
                      'bucket' => 'test',
                  },
              },
          }
      )
    }
    let(:s3_configuration) { OpenStruct.new }
    let(:ui) { OpenStruct.new configuration: configuration }
    let(:empty_ui) { OpenStruct.new configuration: empty_configuration }
    let(:differ) { OpenStruct.new get_diffs: diffs }
    let(:diffs) { OpenStruct.new }
    let(:uploader) { Usmu::UploaderMock.new }
    let(:remote_files) { OpenStruct.new }
    let (:options) { Commander::Command::Options.new }

    it 'raises an error when arguments are specified' do
      expect { plugin.command_deploy(['foo'], options) }.to raise_error('This command does not take arguments')
    end

    it 'raises an error when invalid options are specified' do
      expect { plugin.command_deploy([], []) }.to raise_error('Invalid options')
    end

    it 'gets a DirectoryDiff and passes that to an Uploader' do
      plugin.send :ui=, ui
      expect(Usmu::S3::RemoteFiles).to receive(:new).with(s3_configuration).and_return(remote_files)
      expect(Usmu::Deployment::DirectoryDiff).to receive(:new).with(configuration, remote_files).and_return(differ)
      expect(Usmu::S3::Uploader).to receive(:new).with(configuration, s3_configuration).and_return(uploader)
      expect(Usmu::S3::S3Configuration).to receive(:new).with({'bucket' => 'test'}).and_return(s3_configuration)
      plugin.command_deploy [], options
      expect(uploader.diffs).to eq(diffs)
    end

    it 'it uses default values if not configured' do
      plugin.send :ui=, empty_ui
      expect(Usmu::S3::RemoteFiles).to receive(:new).with(s3_configuration).and_return(remote_files)
      expect(Usmu::Deployment::DirectoryDiff).to receive(:new).with(empty_configuration, remote_files).and_return(differ)
      expect(Usmu::S3::Uploader).to receive(:new).with(empty_configuration, s3_configuration).and_return(uploader)
      expect(Usmu::S3::S3Configuration).to receive(:new).with({}).and_return(s3_configuration)
      plugin.command_deploy [], options
    end

    it 'logs progress' do
      plugin.send :ui=, ui
      expect(Usmu::S3::RemoteFiles).to receive(:new).with(s3_configuration).and_return(remote_files)
      expect(Usmu::Deployment::DirectoryDiff).to receive(:new).with(configuration, remote_files).and_return(differ)
      expect(Usmu::S3::Uploader).to receive(:new).with(configuration, s3_configuration).and_return(uploader)
      expect(Usmu::S3::S3Configuration).to receive(:new).with({'bucket' => 'test'}).and_return(s3_configuration)
      plugin.command_deploy [], options

      # Discard the line from initialization
      @log_output.readline

      expect(@log_output.readline).to eq("   INFO  Usmu::S3 : Gathering information...\n")
      expect(@log_output.readline).to eq("   INFO  Usmu::S3 : Uploading files.\n")
      expect(@log_output.readline).to eq("   INFO  Usmu::S3 : Website updated successfully.\n")
    end
  end
end
