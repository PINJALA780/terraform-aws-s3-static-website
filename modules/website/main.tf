resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
# Enable Versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.example.id

  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.example.id

  index_document {
    suffix = "index.html"
  }
}
# Public Access Configuration
resource "aws_s3_bucket_public_access_block" "public" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Bucket Policy (Public Read)
resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.example.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = "*"
      Action = "s3:GetObject"
      Resource = "${aws_s3_bucket.example.arn}/*"
    }]
  })
}

# Upload index.html Automatically
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.example.id
  key          = "index.html"
  source       = "${path.root}/website/index.html"
  content_type = "text/html"
}
