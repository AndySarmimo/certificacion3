output "website_endpoint"{
    
    value = aws_s3_bucket.bucket_web.website_endpoint
}