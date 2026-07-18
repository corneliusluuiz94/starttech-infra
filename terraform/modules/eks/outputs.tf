output "cluster_name" {
  value = aws_eks_cluster.starttech-cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.starttech-cluster.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.starttech-cluster.certificate_authority[0].data
}

output "node_group_name" {
  value = aws_eks_node_group.starttech-node-group.node_group_name
}

output "cluster_security_group_id" {
  value = aws_eks_cluster.starttech-cluster.vpc_config[0].cluster_security_group_id
}
