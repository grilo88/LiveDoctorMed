
resource "aws_lambda_function" "lambda_edge" {
  filename      = "${path.module}/lambda_function.zip"
  function_name = "${var.project}-url-rewrite"

  role          = aws_iam_role.lambda_edge_role.arn
  handler       = "lambda.handler"
  runtime       = "nodejs18.x"
  publish = true

  source_code_hash = data.archive_file.lambda.output_base64sha256
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda.js"
  output_path = "${path.module}/lambda_function.zip"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_edge_role" {
  name               = "${var.project}-iam-for-lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}