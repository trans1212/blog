#!/bin/bash

# Deploy script for travis

# Deploy to blog.skycoin.net
s3cmd --access_key="${AWS_ACCESS_KEY_ID}" --secret_key="${AWS_SECRET_ACCESS_KEY}" --region=ap-southeast-1 sync --delete-removed --acl-public --guess-mime-type --no-mime-magic --recursive public-blog/ s3://blog.skycoin.net/

# Deploy to www.skycoin.net/blog
s3cmd --access_key="${AWS_ACCESS_KEY_ID}" --secret_key="${AWS_SECRET_ACCESS_KEY}" --region=ap-southeast-1 sync --delete-removed --acl-public --guess-mime-type --no-mime-magic --recursive public-www/ s3://www.skycoin.net/blog/
