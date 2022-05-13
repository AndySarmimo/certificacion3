resource "aws_s3_bucket" "bucket-web" {
  bucket = var.bucketname
  acl    = "public-read"
  policy = file("${path.module}/policy.json")

  website {
    index_document = "index.html"
    error_document = "404.html"
  }
  tags={
      terraform="true"
      website_hosting="true"
  }
  
}



resource "aws_s3_bucket_object" "website_smm"{
    bucket = var.bucketname
    key="index.html"
    source="${path.module}/carpeta/index.html"
    depends_on = [aws_s3_bucket.s3_website_host]
    
}
resource "aws_s3_bucket_object" "error_smm"{
    bucket = var.bucketname
    key="404.html"
    source="${path.module}/carpeta/404.html"
    depends_on = [aws_s3_bucket.s3_website_host]
    
    
}
