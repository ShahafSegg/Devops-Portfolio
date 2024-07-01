resource "aws_eip" "nat_eip" {
  count  = length(var.availability_zones)
  domain = "vpc"
  tags   = { Name = "eip-shahaf" }
}
