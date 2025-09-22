resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "my-test-clevertap"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "app_folder" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "simple-app/"
}

resource "aws_s3_object" "frontend_folder" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "simple-app/simple-frontend/"
}

resource "aws_s3_object" "backend_folder" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "simple-app/simple-backend/"
}