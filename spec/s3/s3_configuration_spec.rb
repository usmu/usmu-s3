require 'usmu/s3/s3_configuration'
require 'ostruct'

RSpec.describe Usmu::S3::S3Configuration do
  let (:empty_configuration) { Usmu::S3::S3Configuration.new({}) }
  let (:configuration) {
    Usmu::S3::S3Configuration.new(
        {
            'region' => '%env{TEST_REGION}',
            'access key' => 'replace %env{TEST_ACCESS_KEY}',
            'secret key' => 'replace %env{TEST_SECRET_KEY}',
            'bucket' => 'replace %env{TEST_BUCKET}',
            'reduced redundancy' => true,
        }
    )
  }

  before do
    allow(ENV).to receive(:'[]').with('AWS_REGION').and_return('us-east-1')
    allow(ENV).to receive(:'[]').with('AWS_ACCESS_KEY_ID').and_return('access_key_test')
    allow(ENV).to receive(:'[]').with('AWS_SECRET_ACCESS_KEY').and_return('secret_key_test')
    allow(ENV).to receive(:'[]').with('TEST_REGION').and_return('ap-southeast-2')
    allow(ENV).to receive(:'[]').with('TEST_ACCESS_KEY').and_return('access_key_test')
    allow(ENV).to receive(:'[]').with('TEST_SECRET_KEY').and_return('secret_key_test')
    allow(ENV).to receive(:'[]').with('TEST_BUCKET').and_return('example.com')
  end

  context '#inspect' do
    it 'does show class name' do
      expect(configuration.inspect.start_with? '#<Usmu::S3::S3Configuration ').to eq(true)
    end

    it 'does show region' do
      expect(configuration.inspect.match(/ region="ap-southeast-2"/)).to_not eq(nil)
    end

    it 'does show access_key' do
      expect(configuration.inspect.match(/ access_key="replace access_key_test"/)).to_not eq(nil)
    end

    it "doesn't show secret_key" do
      expect(configuration.inspect.match(/ secret_key="/)).to eq(nil)
    end

    it 'does show bucket' do
      expect(configuration.inspect.match(/ bucket="replace example.com"/)).to_not eq(nil)
    end
  end

  context '#region' do
    it 'uses AWS SDK environment variables for defaults' do
      expect(empty_configuration.region).to eq('us-east-1')
    end

    it 'replaces environment variables' do
      expect(configuration.region).to eq('ap-southeast-2')
    end
  end

  context '#access_key' do
    it 'uses AWS SDK environment variables for defaults' do
      expect(empty_configuration.access_key).to eq('access_key_test')
    end

    it 'replaces environment variables' do
      expect(configuration.access_key).to eq('replace access_key_test')
    end
  end

  context '#secret_key' do
    it 'uses AWS SDK environment variables for defaults' do
      expect(empty_configuration.secret_key).to eq('secret_key_test')
    end

    it 'replaces environment variables' do
      expect(configuration.secret_key).to eq('replace secret_key_test')
    end
  end

  context '#bucket' do
    it 'has a default value of an empty string' do
      expect(empty_configuration.bucket).to eq('')
    end

    it 'replaces environment variables' do
      expect(configuration.bucket).to eq('replace example.com')
    end
  end

  context '#reduced_redundancy' do
    it 'has a default value of false' do
      expect(empty_configuration.reduced_redundancy).to eq(false)
    end

    it 'returns the "reduced redundancy" key' do
      expect(configuration.reduced_redundancy).to eq(true)
    end
  end

  context '#substitute_env' do
    it 'replaces environment variables' do
      expect(empty_configuration.send :substitute_env, '%env{AWS_REGION}').to eq('us-east-1')
    end

    it 'replaces multiple environment variables' do
      expect(empty_configuration.send :substitute_env, '%env{AWS_REGION},%env{TEST_REGION}').to eq('us-east-1,ap-southeast-2')
    end
  end

  context '#credentials' do
    it 'returns a new Aws::Credentials from it\'s settings' do
      creds = OpenStruct.new {}
      allow(Aws::Credentials).to receive(:new).with('access_key_test', 'secret_key_test').and_return(creds)
      expect(empty_configuration.credentials).to eq(creds)
    end
  end
end
