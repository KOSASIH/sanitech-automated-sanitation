resource "aws_glacier_vault_lock_policy" "example" {
  policy = jsonencode({
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Sid" = "RetentionRule"
        "Effect" = "Allow"
        "Principal" = {
          "AWS" = "*"
        }
        "Action" = "glacier:InitiateJob"
        "Resource" = aws\_glacier\_vault.example.arn
        "Condition" = {
          "DateLessThan" = {
            "aws:CurrentTime" = "2025-12-31T00:00:00Z"
          }
        }
      }
    ]
  })
}

resource "aws\_glacier\_vault" "example" {
  name = "example-vault"
}
