resource "aws_acm_certificate" "covidshield" {
  domain_name               = var.route53_zone_name
  subject_alternative_names = ["*.${var.route53_zone_name}"]
  validation_method         = "DNS"

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }

  lifecycle {
    create_before_destroy = true
  }
}

###
# Cloudfront requires client certificate to be created in us-east-1
###
resource "aws_acm_certificate" "retrieval_covidshield" {
  provider          = aws.us-east-1
  domain_name       = "retrieval.${var.route53_zone_name}"
  validation_method = "DNS"

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "covidshield_certificate_validation" {
  zone_id = aws_route53_zone.covidshield.zone_id

  for_each = {
    for dvo in aws_acm_certificate.covidshield.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type

  ttl = 60
}

resource "aws_route53_record" "retrieval_covidshield_certificate_validation" {
  zone_id = aws_route53_zone.covidshield.zone_id

  for_each = {
    for dvo in aws_acm_certificate.retrieval_covidshield.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value

    }
  }

  name    = each.value.name
  records = [each.value.record]
  type    = each.value.type

  ttl = 60
}

resource "aws_acm_certificate_validation" "covidshield" {
  certificate_arn         = aws_acm_certificate.covidshield.arn
  validation_record_fqdns = [for record in aws_route53_record.covidshield_certificate_validation : record.fqdn]
}

resource "aws_acm_certificate_validation" "retrieval_covidshield" {
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.retrieval_covidshield.arn
  validation_record_fqdns = [for record in aws_route53_record.retrieval_covidshield_certificate_validation : record.fqdn]
}
