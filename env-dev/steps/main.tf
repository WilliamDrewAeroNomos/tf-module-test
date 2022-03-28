

#------------------------------------------------------
# Create IAM role for AWS Step Function
#------------------------------------------------------
resource "aws_iam_role" "iam_for_sfn" {
  name = "stepFunctionExecutionIAMRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "states.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

#------------------------------------------------------
# Create policy to publish to SMS
#------------------------------------------------------
resource "aws_iam_policy" "policy_publish_sms" {
  name = "stepFunctionSNSPublishPolicy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
              "sns:Publish",
              "sns:SetSMSAttributes",
              "sns:GetSMSAttributes"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

#------------------------------------------------------
# Create policy to invoke Lambda function
#------------------------------------------------------
resource "aws_iam_policy" "policy_invoke_lambda" {
  name = "stepFunctionLambdaInvocationPolicy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction",
                "lambda:InvokeAsync"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


#------------------------------------------------------
#  Attach policy for invoking functions to IAM Role
#------------------------------------------------------

resource "aws_iam_role_policy_attachment" "iam_for_sfn_attach_policy_invoke_lambda" {
  role       = aws_iam_role.iam_for_sfn.name
  policy_arn = aws_iam_policy.policy_invoke_lambda.arn
}

#------------------------------------------------------
#  Attach policy for publishing to SMS to IAM Role
#------------------------------------------------------
 
resource "aws_iam_role_policy_attachment" "iam_for_sfn_attach_policy_publish_sns" {
  role       = aws_iam_role.iam_for_sfn.name
  policy_arn = aws_iam_policy.policy_publish_sms.arn
}