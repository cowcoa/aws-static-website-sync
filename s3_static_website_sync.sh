#!/bin/bash

script_name=$(basename $0)
# S3 bucket to be synchronized.
buckname_name="aws-static-website-bucket"
# CloudFront distribution ID associated with the s3 static website.
cdn_distribution_id="A1B2C3D4E5F6G7"
# Log file.
s3_sync_result="s3_sync_result.log"
# AWS CLI credential profile.
aws_cli_profile="zxcow"

echo "Uploading..."
aws s3 sync . s3://${buckname_name} \
	--exact-timestamps \
	--delete \
	--no-progress \
	--exclude=$script_name \
	--exclude=$s3_sync_result \
	--output=text \
	--profile $aws_cli_profile \
	| tee $s3_sync_result
echo 

echo "Invalidating CDN cache..."
while IFS= read -r line; do
    # echo "Text read from $s3_sync_result: $line"

    str="$line"
	delimiter=$buckname_name
	s=$str$delimiter
	array=();
	while [[ $s ]]; do
	    array+=( "${s%%"$delimiter"*}" );
	    s=${s#*"$delimiter"};
	done;
	declare -p array &> /dev/null
	cf_cache_path=${array[1]}
	
	echo "CloudFront Distribution invalidation path: $cf_cache_path"
    #aws cloudfront create-invalidation --distribution-id $cdn_distribution_id --paths "$cf_cache_path"
done < $s3_sync_result

echo "Done"
