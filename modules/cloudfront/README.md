## data aws_acm_certificate
```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement1",
			"Effect": "Allow",
			"Action": [
				"acm:ListCertificates",
				"acm:DescribeCertificate",
				"acm:GetCertificate",
				"acm:ListTagsForCertificate"
			],
			"Resource": [
				"*"
			]
		}
	]
}
```

## aws_cloudfront_origin_access_identity 

```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement1",
			"Effect": "Allow",
			"Action": [
				"cloudfront:CreateCloudFrontOriginAccessIdentity",
				"cloudfront:GetCloudFrontOriginAccessIdentity",
				"cloudfront:DeleteCloudFrontOriginAccessIdentity",
				"cloudfront:UpdateCloudFrontOriginAccessIdentity"
			],
			"Resource": [
				"*"
			]
		}
	]
}
```

## aws_cloudfront_distribution 
```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement1",
			"Effect": "Allow",
			"Action": [
				"cloudfront:CreateDistribution",
				"cloudfront:GetDistribution",
				"cloudfront:UpdateDistribution",
				"cloudfront:DeleteDistribution",
				"cloudfront:ListDistributions",
				"cloudfront:TagResource",
				"cloudfront:UntagResource",
				"cloudfront:ListTagsForResource"
			],
			"Resource": [
				"*"
			]
		}
	]
}
```


## All in
```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement1",
			"Effect": "Allow",
			"Action": [
				"acm:ListCertificates",
				"acm:DescribeCertificate",
				"acm:GetCertificate",
				"acm:ListTagsForCertificate",
				"cloudfront:CreateCloudFrontOriginAccessIdentity",
				"cloudfront:GetCloudFrontOriginAccessIdentity",
				"cloudfront:DeleteCloudFrontOriginAccessIdentity",
				"cloudfront:UpdateCloudFrontOriginAccessIdentity",
				"cloudfront:CreateDistribution",
				"cloudfront:GetDistribution",
				"cloudfront:UpdateDistribution",
				"cloudfront:DeleteDistribution",
				"cloudfront:ListDistributions",
				"cloudfront:TagResource",
				"cloudfront:UntagResource",
				"cloudfront:ListTagsForResource"
			],
			"Resource": [
				"*"
			]
		}
	]
}
```