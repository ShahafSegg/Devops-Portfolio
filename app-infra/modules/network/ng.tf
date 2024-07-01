resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.availability_zones)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id
  tags          = { Name = "ng-shahaf" }
}
