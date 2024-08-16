

```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement1",
			"Effect": "Allow",
			"Action": [
				"kms:TagResource",
				"logs:CreateLogGroup",
				"iam:CreateRole",
				"logs:TagResource",
				"iam:TagRole",
				"kms:CreateKey",
				"logs:DescribeLogGroups",
				"logs:ListTagsLogGroup",
				"iam:GetRole",
				"iam:ListRolePolicies",
				"iam:ListAttachedRolePolicies",
				"iam:ListInstanceProfilesForRole",
				"kms:ListResourceTags",
				"kms:DescribeKey",
				"kms:GetKeyPolicy",
				"kms:GetKeyRotationStatus",
				"logs:DeleteLogGroup",
				"iam:DeleteRole",
				"kms:ScheduleKeyDeletion",
				"ecs:CreateCluster",
				"iam:AttachRolePolicy",
				"ecs:TagResource",
				"ecs:DescribeClusters",
				"ecs:DeleteCluster"
			],
			"Resource": "*"
		}
	]
}
```