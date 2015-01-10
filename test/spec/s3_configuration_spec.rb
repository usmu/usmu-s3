require 'usmu/s3/s3_configuration'

RSpec.describe Usmu::S3::S3Configuration do
  let (:empty_configuration) { Usmu::S3::S3Configuration.new({}) }

  it "doesn't show secret_key in #inspect" do
    expect(empty_configuration.inspect.match(/ secret_key="/)).to eq(nil)
  end

  context 'uses AWS API environment variables for defaults' do
    before do
      allow(ENV).to receive(:'[]').with('AWS_REGION').and_return('us-east-1')
      allow(ENV).to receive(:'[]').with('AWS_ACCESS_KEY_ID').and_return('access_key_test')
      allow(ENV).to receive(:'[]').with('AWS_SECRET_ACCESS_KEY').and_return('secret_key_test')
    end

    it 'in #region' do
      expect(empty_configuration.region).to eq('us-east-1')
    end

    it 'in #access_key' do
      expect(empty_configuration.access_key).to eq('access_key_test')
    end

    it 'in #secret_key' do
      expect(empty_configuration.secret_key).to eq('secret_key_test')
    end
  end

  context 'replaces environment variables' do
    let (:configuration) {
      Usmu::S3::S3Configuration.new(
          {
              'region' => '%env{TEST_REGION}',
              'access key' => 'replace %env{TEST_ACCESS_KEY}',
              'secret key' => 'replace %env{TEST_SECRET_KEY}',
              'bucket' => 'replace %env{TEST_BUCKET}',
          }
      )
    }

    before do
      allow(ENV).to receive(:'[]').with('TEST_REGION').and_return('us-east-1')
      allow(ENV).to receive(:'[]').with('TEST_ACCESS_KEY').and_return('access_key_test')
      allow(ENV).to receive(:'[]').with('TEST_SECRET_KEY').and_return('secret_key_test')
      allow(ENV).to receive(:'[]').with('TEST_BUCKET').and_return('example.com')
    end

    it 'in #region' do
      expect(configuration.region).to eq('us-east-1')
    end

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
