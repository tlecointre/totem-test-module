locals {
  common_tags = map(
      "Environment", "${var.environment}",
      "Deployment", "Terraform"
  )
}

// EC2 main instance
resource "aws_instance" "instance" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  depends_on = [aws_s3_bucket_object.object]
  tags       = merge(map("Name","${var.project_name}-${var.environment}"), local.common_tags, var.additional_tags)
}

// S3 Bucket which hosts inits scripts
resource "aws_s3_bucket" "bucket" {
  bucket = "${project_name}-${environment}-bucket"
  acl    = "private"

  tags = merge(map("Name","${var.project_name}-${var.environment}-bucket"), local.common_tags, var.additional_tags)
}

resource "aws_s3_bucket_object" "object" {
  for_each = fileset("scripts/", "*")
  bucket   = aws_s3_bucket.bucket.id
  key      = each.value
  source   = "scripts/${each.value}"
  etag     = filemd5("scripts/${each.value}")
}

// Elastic IP
resource "aws_eip" "eip" {
  vpc      = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.instance.id
  allocation_id = aws_eip.eip.id
}