
# Outputs

output "vpc-main-id" {
  value = module.ahroc_main_vpc.vpc-main-id
}
output "public_subnet_1_id" {
  value = aws_subnet.main-public-1.id
}
output "public_subnet_2_id" {
  value = aws_subnet.main-public-2.id
}
output "public_subnet_3_id" {
  value = aws_subnet.main-public-3.id
}