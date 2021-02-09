#EKSmaster
resource "aws_iam_role" "eks-master-iam" {
  name = "${var.resource_prefix}-eks-master-iam-01"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-master-iam.name
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks-master-iam.name
}

#EKSworkers
resource "aws_iam_role" "eks-node-iam" {
  name = "${var.resource_prefix}-eks-node-iam-01"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-iam.name
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node-iam.name
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node-iam.name
}

resource "aws_iam_instance_profile" "node" {
  name = "${var.resource_prefix}-eks-instance-node-01"
  role = aws_iam_role.eks-node-iam.name
}

#EKSworkers metrics
resource "aws_iam_policy" "policy_cloudwatch" {
  name        = "${var.resource_prefix}-eks-cloudwatch-policy-01"
  description = "This policy allow EKS workers to send logs into cloudwatch"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:CreateLogGroup",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonCloudwatch" {
  role       = aws_iam_role.eks-node-iam.name
  policy_arn = aws_iam_policy.policy_cloudwatch.arn
}

#EKSworkers AutoScaling
resource "aws_iam_policy" "policy_autoscalingeks" {
  name        = "${var.resource_prefix}-eks-autoscaling-policy"
  description = "ThispolicyallowEKSworkersautoscale"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeTags",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeLaunchTemplateVersions"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks-node-autoscaling" {
  role       = aws_iam_role.eks-node-iam.name
  policy_arn = aws_iam_policy.policy_autoscalingeks.arn
}
