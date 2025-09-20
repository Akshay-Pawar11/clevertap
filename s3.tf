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

# resource "aws_s3_object" "app_files" {
#   for_each = fileset("${path.module}/simple-app", "**/*")
  
#   bucket = aws_s3_bucket.simple_app.bucket
#   key    = each.value                                   
#   source = "${path.module}/simple-app/${each.value}"    
  
#   source_hash = filemd5("${path.module}/simple-app/${each.value}")
  
#   content_type = lookup({
#     "html" = "text/html"
#     "css"  = "text/css"
#     "js"   = "application/javascript"
#     "json" = "application/json"
#     "txt"  = "text/plain"
#   }, split(".", each.value)[length(split(".", each.value)) - 1], "binary/octet-stream")
# }
