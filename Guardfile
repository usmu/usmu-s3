# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec, cmd: 'rspec', spec_paths: ['test/spec'] do
  watch(%r{^test/spec/.+_spec\.rb$})
  watch(%r{^lib/usmu/s3/(.+)\.rb$})     { |m| "test/spec/#{m[1]}_spec.rb" }
  watch(%r{^test/spec/support})      { 'test/spec' }
  watch('test/spec/spec_helper.rb')  { 'test/spec' }

  # Turnip features and steps
  #watch(%r{^spec/acceptance/(.+)\.feature$})
  #watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$})   { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance' }
end
