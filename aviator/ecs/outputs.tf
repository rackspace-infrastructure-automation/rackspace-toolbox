output "cluster_id" {
  description = "The ID of the cluster"
  value       = "${aws_ecs_cluster.ecs-cluster.id}"
}

output "cluster_arn" {
  description = "The ARN of the cluster"
  value       = "${aws_ecs_cluster.ecs-cluster.arn}"
}
