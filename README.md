# AWS S3 static website sync script
When we use the AWS S3 bucket to build a static website, we need to track changes of the files in the bucket and refresh the cache in CloudFront if necessary.
This script can help you achieve this goal. It can synchronize files in local folder to the S3 bucket. When files in local folder are changed(add/delete/update), it will only upload those changed files. Files deleted from the local folder are also deleted from the S3 bucket.
The script will also record the updated objects in S3 bucket and invalidate the files cached in CloudFront.

## Usage
1. Adjust parameters in the script(including S3 bucket name, CloudFront distribution ID, AWS CLI credential profile, etc.).
2. Run script:
    > ./s3_static_website_sync.sh
