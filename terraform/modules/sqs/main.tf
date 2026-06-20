# Fila principal de doações
resource "aws_sqs_queue" "donations" {
  name                       = "${var.project_name}-${var.environment}-donations"
  message_retention_seconds  = 86400   # 1 dia
  visibility_timeout_seconds = 30
  receive_wait_time_seconds  = 20      # long polling

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.donations_dlq.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-donations-queue"
  }
}

# Dead Letter Queue
resource "aws_sqs_queue" "donations_dlq" {
  name                      = "${var.project_name}-${var.environment}-donations-dlq"
  message_retention_seconds = 1209600  # 14 dias

  tags = {
    Name = "${var.project_name}-${var.environment}-donations-dlq"
  }
}

# Policy para o donation-service publicar na fila
resource "aws_sqs_queue_policy" "donations" {
  queue_url = aws_sqs_queue.donations.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { AWS = var.eks_node_role_arn }
      Action    = ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:DeleteMessage"]
      Resource  = aws_sqs_queue.donations.arn
    }]
  })
}