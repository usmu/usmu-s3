require 'usmu/configuration'
require 'usmu/s3/s3_configuration'
require 'usmu/s3/uploader'
require 'usmu/s3_service_mock'
require 'ostruct'

RSpec.describe Usmu::S3::Uploader do
  let (:configuration) { Usmu::Configuration.from_hash({}) }
  let (:s3_configuration) {
    Usmu::S3::S3Configuration.new(
        {
            'access key' => 'access',
            'secret key' => 'secret',
            'region' => 'us-east-1',
            'bucket' => 'bucket',
        }
    )
  }
  let (:creds) { OpenStruct.new({ access_key: 'access', secret_key: 'secret' }) }
  let (:s3) { Usmu::S3ServiceMock.new([]) }
  let (:uploader) { Usmu::S3::Uploader.new(configuration, s3_configuration) }

  before do
    expect(s3_configuration).to receive(:credentials).and_return(creds)
    expect(Aws::S3::Resource).to receive(:new).with({credentials: creds, region: 'us-east-1'}).and_return(s3)
  end

  context '#initialize' do
    it 'sets up instance variables' do
      expect(uploader.send :configuration).to eq(configuration)
      expect(uploader.send :bucket).to eq(s3)
      expect(s3.get_bucket).to eq('bucket')
      expect(uploader.send(:log).is_a? Logging::Logger).to eq(true)
      expect(uploader.send(:log).name).to eq(described_class.name)
    end
  end

  context '#push' do
    it 'pushes new and updated files and deletes old files' do
      expect(uploader).to receive(:push_local).with(['local.html'])
      expect(uploader).to receive(:push_local).with(['updated.html'])
      expect(uploader).to receive(:delete_remote).with(['remote.html'])

      uploader.push({
                        local: ['local.html'],
                        updated: ['updated.html'],
                        remote: ['remote.html'],
                    })
    end
  end

  context '#push_local' do
    let (:io) { OpenStruct.new {} }

    before do
      allow(File).to receive(:open).with('site/local.html', 'r').and_yield(io)
    end

    it 'sends a request to S3 to push named files' do
      expect(s3).to receive(:put_object).with({key: 'local.html', body: io})
      uploader.send :push_local, ['local.html']
    end

    it 'logs files as they are pushed' do
      uploader.send :push_local, ['local.html']
      expect(@log_output.readline).to eq("SUCCESS  Usmu::S3::Uploader : Uploading local.html\n")
    end
  end

  context '#delete_remote' do
    it 'sends a request to S3 to delete named files' do
      expect(s3).to receive(:delete_objects).with({delete: {objects: [{key: 'remote.html'}]}})
      uploader.send :delete_remote, ['remote.html']
    end

    it 'sends requests in batches of 1000' do
      expect(s3).to receive(:delete_objects).with({delete: {objects: (0...1000).map {|f| {key: "#{f}.html"}}}})
      expect(s3).to receive(:delete_objects).with({delete: {objects: (1000..1100).map {|f| {key: "#{f}.html"}}}})
      uploader.send(:delete_remote, (0..1100).map {|f| "#{f}.html"})
    end

    it 'only sends one request if we have exactly one batch of files' do
      expect(s3).to receive(:delete_objects).with({delete: {objects: (0...1000).map {|f| {key: "#{f}.html"}}}})
      uploader.send(:delete_remote, (0...1000).map {|f| "#{f}.html"})
    end

    it 'logs files as they are deleted' do
      uploader.send :delete_remote, ['remote.html']
      expect(@log_output.readline).to eq("SUCCESS  Usmu::S3::Uploader : Deleting remote.html\n")
    end
  end
end
