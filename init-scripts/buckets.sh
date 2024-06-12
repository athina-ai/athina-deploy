#!/usr/bin/env bash
awslocal s3 mb s3://athina-data-import
awslocal s3api put-bucket-cors --bucket athina-data-import --cors-configuration '{"CORSRules":[{"AllowedHeaders":["*"],"AllowedMethods":["GET", "POST", "PUT", "DELETE", "HEAD"],"AllowedOrigins":["http://localhost:3000"],"ExposeHeaders":["ETag"]}]}' --endpoint-url=http://localhost:4566
awslocal s3 mb s3://uploads
awslocal s3api put-bucket-cors --bucket uploads --cors-configuration '{"CORSRules":[{"AllowedHeaders":["*"],"AllowedMethods":["GET", "POST", "PUT", "DELETE", "HEAD"],"AllowedOrigins":["http://localhost:3000"],"ExposeHeaders":["ETag"]}]}' --endpoint-url=http://localhost:4566
