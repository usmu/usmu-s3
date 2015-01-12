require 'usmu/s3/s3_configuration'
require 'usmu/s3/remote_files'
require 'usmu/s3_service_mock'
require 'ostruct'

RSpec.describe Usmu::S3::RemoteFiles do
  let(:now) { Time.now }
  let(:configuration) {
    Usmu::S3::S3Configuration.new(
        {
            'access key' => 'access',
            'secret key' => 'secret',
            'region' => 'us-east-1',
            'bucket' => 'bucket',
        }
    )
  }
  let(:creds) { OpenStruct.new({ access_key: 'access', secret_key: 'secret' }) }
  let(:s3) {
    Usmu::S3ServiceMock.new(
        [
            OpenStruct.new({ key: 'index.html', etag: '"dffd613ea3d712d38c230c810be2e4a6"', last_modified: now }),
            OpenStruct.new({ key: 'sitemap.xml', etag: '"dffd613ea3d712d38c230c810be2e4a6-5"', last_modified: now }),
        ]
    )
  }
  let(:remote) { Usmu::S3::RemoteFiles.new(configuration) }

  before do
    expect(configuration).to receive(:credentials).and_return(creds)
    expect(Aws::S3::Resource).to receive(:new).with({credentials: creds, region: 'us-east-1'}).and_return(s3)
  end

  context '#initialize' do
    it 'creates an S3 resource instance' do
      remote
      expect(remote.send :s3).to eq(s3)
    end

    it 'finds the relevant S3 bucket' do
      remote
      expect(remote.send :bucket).to eq(s3)
      expect(s3.get_bucket).to eq(configuration.bucket)
    end
  end

  context '#files_list' do
    it 'returns a list of file names' do
      expect(remote.files_list.sort).to eq(['index.html', 'sitemap.xml'])
    end
  end

  context '#stat' do
    it 'returns a hash of information' do
      expect(remote.stat('index.html')).to eq({md5: 'dffd613ea3d712d38c230c810be2e4a6', mtime: now})
    end

    it 'doesn\'t return an :md5 element for multi-part uploads' do
      expect(remote.stat('sitemap.xml')).to eq({md5: nil, mtime: now})
    end

    it 'returns nil if there is no information available' do
      expect(remote.stat('jquery.js')).to eq(nil)
    end
  end

  context '#objects' do
    it 'returns a list of objects about files' do
      objs = remote.send :objects
      expect(objs.length).to eq(2)
      expect(objs.map {|o| o.key }.sort).to eq(['index.html', 'sitemap.xml'])
    end
  end
end
