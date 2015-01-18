# usmu-s3

[![Build Status](https://travis-ci.org/usmu/usmu-s3.svg?branch=master)](https://travis-ci.org/usmu/usmu-s3)
[![Dependency Status](https://gemnasium.com/usmu/usmu-s3.svg)](https://gemnasium.com/usmu/usmu-s3)
[![Code Climate](https://codeclimate.com/github/usmu/usmu-s3/badges/gpa.svg)](https://codeclimate.com/github/usmu/usmu-s3)

**Source:** [https://github.com/usmu/usmu-s3](https://github.com/usmu/usmu-s3)  
**Author:** Matthew Scharley  
**Contributors:** [See contributors on GitHub][gh-contrib]  
**Bugs/Support:** [Github Issues][gh-issues]  
**Copyright:** 2014  
**License:** [MIT license][license]  
**Status:** Active

## Synopsis

Allows you to deploy your [Usmu][usmu] website to Amazon's S3 service.

## Installation

    $ gem install usmu-s3

OR

    $ echo 'gem "usmu-s3"' >> Gemfile
    $ bundle install

Usmu will automatically detect any plugins available and automatically make them available.

## Configuration

You can configure this plugin in your `usmu.yml` file:

    plugin:
      s3:
        access_key: '%env{AWS_ACCESS_KEY_ID}'
        secret_key: '%env{AWS_SECRET_ACCESS_KEY}'
        region: 'us-east-1'
        bucket: 'usmu.org'

All S3 configuration options can be pulled from environment variables as shown above. Your access key and secret key
will default to the above environment variables (the same ones used by the SDK) if not specified.

## Usage

    $ usmu s3 deploy

  [gh-contrib]: https://github.com/usmu/usmu-s3/graphs/contributors
  [gh-issues]: https://github.com/usmu/usmu-s3/issues
  [license]: https://github.com/usmu/usmu-s3/blob/master/LICENSE.md
  [usmu]: https://github.com/usmu/usmu
