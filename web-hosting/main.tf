
locals {
  mime_types = jsondecode(file("${path.module}/mime.json"))

}



resource "aws_s3_bucket" "bucket_web" {
  bucket = var.bucketname
  acl    = "public-read"
  # policy = file("${path.module}/policy.json")
  policy = data.aws_iam_policy_document.website_policy.json
  website {
    index_document = "index.html"
    error_document = "404.html"
  }
  tags={
      terraform="true"
      website_hosting="true"
  }
  
}

# resource "aws_s3_bucket_object" "website_smm"{
#     bucket = aws_s3_bucket.bucket_web.id
#     key="index.html"
#     content_type="text/html"
#     source="${path.module}/dist/flashcard-frontend/index.html"
#     #depends_on = [aws_s3_bucket.bucket_web]
    
    
# }
resource "aws_s3_bucket_object" "website_smm"{
    bucket = aws_s3_bucket.bucket_web.id
    for_each = fileset("${path.module}/dist/flashcard-frontend/","*")
    key=each.value
    content_type=lookup(local.mime_types, regex("\\.[^.]+$", each.value), null)
    # content_type="text/html"
    source="${path.module}/dist/flashcard-frontend/${each.value}"
    #depends_on = [aws_s3_bucket.bucket_web]
    
    
}
resource "aws_s3_bucket_object" "error_smm"{
    bucket = aws_s3_bucket.bucket_web.id
    key="404.html"
    content_type="text/html"
    source="${path.module}/carpeta/404.html"
    #depends_on = [aws_s3_bucket.bucket_web]
    
    
}
