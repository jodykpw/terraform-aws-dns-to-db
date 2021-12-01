# AWS Route 53 Variables
variable "route53_mydomain" {
  description = "Domain Name"
  type = string 
  default = "domain.com"
}

variable "route53_webapps_dns" {
  description = "WebApps DNS Name"
  type = string 
  default = "myapps.domain.com"
}
