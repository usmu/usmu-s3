require 'usmu/s3/s3_configuration'

ENV['TEST_ACCESS_KEY'] = 'access_key_test'
ENV['TEST_SECRET_KEY'] = 'secret_key_test'
ENV['TEST_BUCKET'] = 'example.com'

RSpec.describe Usmu::S3::S3Configuration do
  let (:configuration) {
    Usmu::S3::S3Configuration.new(
        {
            'access key' => 'replace %env{TEST_ACCESS_KEY}',
            'secret key' => 'replace %env{TEST_SECRET_KEY}',
            'bucket' => 'replace %env{TEST_BUCKET}',
        }
    )
  }

  it "doesn't show secret_key in #inspect" do
    expect(configuration.inspect.match(/ secret_key="/)).to eq(nil)
  end

  context 'replaces environment variables' do
    it 'in #access_key' do
      expect(configuration.access_key).to eq('replace access_key_test')
    end

    it 'in #secret_key' do
      expect(configuration.secret_key).to eq('replace secret_key_test')
    end

    it 'in #bucket' do
      expect(configuration.bucket).to eq('replace example.com')
    end
  end
end
