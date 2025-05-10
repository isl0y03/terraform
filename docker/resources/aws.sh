# aws sts assume-roleコマンドを実行して、Terraform用IAMロールに切り替える
function switch_role() {
  if [ -z ${ROLE_ARN} ]; then
    echo "ROLE_ARN must be set."
    return 1
  fi
  ROLE_SESSION_NAME="terraform-session"
  PROFILE=${PROFILE:-"default"}

  # aws sts assume-roleコマンドを実行して一時的な認証情報を取得
  ASSUME_ROLE_OUTPUT=$(aws sts assume-role \
    --role-arn "$ROLE_ARN" \
    --role-session-name "$ROLE_SESSION_NAME" \
    --profile "$PROFILE")

  # コマンドの成功を確認
  if [ $? -ne 0 ]; then
    echo "Failed to assume role: $ROLE_ARN"
    exit 1
  fi

  # 一時的な認証情報を変数に格納
  export AWS_ACCESS_KEY_ID=$(echo "$ASSUME_ROLE_OUTPUT" | jq -r '.Credentials.AccessKeyId')
  export AWS_SECRET_ACCESS_KEY=$(echo "$ASSUME_ROLE_OUTPUT" | jq -r '.Credentials.SecretAccessKey')
  export AWS_SESSION_TOKEN=$(echo "$ASSUME_ROLE_OUTPUT" | jq -r '.Credentials.SessionToken')

  echo "Successfully switched role to: $ROLE_ARN"
}

switch_role
