#!/usr/bin/env bash

#set mfa arn token
MFA_ARN=""

#set aws access key here
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_DEFAULT_REGION=""


#configure aws credentials
ASSUMED_ROLE=""
configure_aws() {
	[[ -n $AWS_ACCESS_KEY_ID ]] && aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
	[[ -n $AWS_SECRET_ACCESS_KEY ]] && aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
	[[ -n $AWS_SESSION_TOKEN ]] && aws configure set aws_session_token "$AWS_SESSION_TOKEN"
	[[ -n $AWS_DEFAULT_REGION ]] && aws configure set region "$AWS_DEFAULT_REGION" 
}

