## aws_s3_bucket
```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"s3:CreateBucket",
				"s3:PutBucketPolicy",
				"s3:GetBucketPolicy",
				"s3:DeleteBucketPolicy",
				"s3:PutObject",
				"s3:ListBucket",
				"s3:GetBucketLocation",
				"s3:DeleteBucket",
				"s3:DeleteObject",
				"s3:DeleteObjectVersion",
				"s3:GetObject",
				"s3:GetBucketAcl",
				"s3:GetBucketCors",
				"s3:GetBucketWebsite",
				"s3:GetBucketVersioning",
				"s3:GetAccelerateConfiguration",
				"s3:GetBucketRequestPayment",
				"s3:GetBucketLogging",
				"s3:GetLifecycleConfiguration",
				"s3:GetReplicationConfiguration",
				"s3:GetEncryptionConfiguration",
				"s3:GetObjectAttributes",
				"s3:GetBucketTagging",
				"s3:GetBucketObjectLockConfiguration",
				"s3:PutBucketTagging",
				"s3:ListBucketVersions"
			],
			"Resource": [
				"arn:aws:s3:::*",
				"arn:aws:s3:::*/*"
			]
		}
	]
}
```
## aws_s3_bucket_website_configuration
```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement1",
			"Effect": "Allow",
			"Action": [
				"s3:PutBucketWebsite",
				"s3:DeleteBucketWebsite"
			],
			"Resource": [
				"*"
			]
		}
	]
}
```
## aws_s3_object
```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement1",
			"Effect": "Allow",
			"Action": [
				"s3:GetObjectTagging"
			],
			"Resource": [
				"*"
			]
		}
	]
}
```