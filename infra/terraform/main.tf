resource "aws_cognito_user_pool" "mixfast_cognito_user_pool" {
  name = "${var.name}_user_pool"

  username_attributes = ["email"]
  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject = "Account Confirmation"
    email_message = "Your confirmation code is {####}"
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "cpf"
    required                 = false
    string_attribute_constraints {
      min_length = 11
      max_length = 11
    }
  }

  tags = var.tags
}

resource "aws_cognito_user_pool_client" "mixfast_cognito_user_pool_client" {
  name = "${var.name}_cognito_client"

  user_pool_id                  = aws_cognito_user_pool.mixfast_cognito_user_pool.id
  generate_secret               = false
  refresh_token_validity        = 90
  prevent_user_existence_errors = "ENABLED"

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["implicit"]
  allowed_oauth_scopes                 = ["email", "openid"]
  supported_identity_providers         = ["COGNITO"]
  callback_urls                        = ["https://example.com"]

  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]
}

resource "aws_cognito_user_pool_domain" "mixfast_cognito_user_pool_domain-domain" {
  domain       = var.name
  user_pool_id = aws_cognito_user_pool.mixfast_cognito_user_pool.id
}