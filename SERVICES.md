# Terraform サービス一覧（概要）4

このリポジトリで用意している主な Terraform モジュール/サービスの一覧と概要です。詳細は各ディレクトリの `README.md` を参照してください。

## ネットワーク / 基盤
- `vpc/`: VPC 作成モジュール。サブネット、ルート、NAT、エンドポイント等。例・ラッパーあり。
- `transit-gateway/`: TGW とアタッチメントの作成。
- `vpn-gateway/`: VPN ゲートウェイの作成とアタッチ。
- `customer-gateway/`: カスタマーゲートウェイ（オンプレ等）設定。
- `network-firewall/`: AWS Network Firewall 構築。
- `route53/`: Hosted Zone/レコード管理。

## 負荷分散 / CDN
- `alb/`: Application Load Balancer。
- `elb/`: Classic/Network Load Balancer 系。
- `cloudfront/`: CDN ディストリビューション。
- `global-accelerator/`: Global Accelerator 設定。

## コンピュート / コンテナ
- `ec2-instance/`: 単体 EC2 の構築。
- `autoscaling/`: Auto Scaling グループ。
- `ecs/`: ECS クラスター/サービス関連。
- `eks/`: EKS クラスター、ノードグループ等。
- `eks-pod-identity/`: Pod Identity 関連設定。
- `batch/`: AWS Batch 環境。
- `lambda/`: Lambda 関連（関数、ロール、イベント）。
- `terraform-aws-app-runner/`: App Runner。

## ストレージ / データ
- `s3-bucket/`: S3 バケット作成と各種設定。
- `efs/`: EFS ファイルシステム。
- `dynamodb-table/`: DynamoDB テーブルとオートスケーリング。
- `ecr/`: ECR リポジトリ。
- `elasticache/`: Redis/Memcached クラスタ。
- `memory-db/`: MemoryDB クラスタ。
- `msk-kafka-cluster/`: MSK Kafka。
- `opensearch/`: OpenSearch ドメイン。
- `redshift/`: Redshift クラスタ。

## データベース
- `rds/`: RDS（各種エンジン）インスタンス/オプション。
- `rds-aurora/`: Aurora クラスタ。
- `rds-proxy/`: RDS Proxy。

## メッセージング / 連携
- `sqs/`: SQS キュー。
- `sns/`: SNS トピック。
- `eventbridge/`: ルール/ターゲット等のイベント連携。
- `appsync/`: AppSync GraphQL API。
- `apigateway-v2/`: HTTP/WebSocket API。

## セキュリティ / ID 管理
- `iam/`: IAM ユーザー/ロール/ポリシー等。
- `kms/`: KMS キー。
- `secrets-manager/`: シークレット管理。
- `security-group/`: SG のテンプレート群。
- `key-pair/`: EC2 キーペアの管理。
- （監査・コンプライアンス）AWS Config（未整備・テンプレ用意可）
- （監査・コンプライアンス）CloudTrail（未整備・テンプレ用意可）
- （セキュリティ可視化）Security Hub（未整備・テンプレ用意可）
- （脅威検出）GuardDuty（未整備・テンプレ用意可）
- （データ保護）Macie（未整備・テンプレ用意可）
- （調査）Detective（未整備・テンプレ用意可）
- （バックアップ）AWS Backup（未整備・テンプレ用意可）
- （アプリ保護）WAFv2（未整備・テンプレ用意可）
- （DDoS 保護）AWS Shield（未整備・テンプレ用意可）

## 監視 / 運用
- `cloudwatch/`: アラーム、ログ、ダッシュボード。
- `notify-slack/`: 通知連携（Slack 通知）。
- `managed-service-prometheus/`: AMP。
- `managed-service-grafana/`: AMG。
- `datadog-forwarders/`: Datadog 連携（Forwarder 等）。

## 分析 / ビッグデータ
- `emr/`: EMR クラスタ。
- `dms/`: データ移行サービス（DMS）。
- `fsx/`: FSx ファイルシステム。

## 証明書 / 設定管理
- `acm/`: ACM 証明書発行/検証。
- `appconfig/`: アプリ設定管理（Feature Flag 等）。
- `ssm-parameter/`: パラメータストア。

## ツール / 補助
- `atlantis/`: Atlantis 用のインフラ。

---

### 使い方（共通の流れ）
1. 作成したいサービスのディレクトリへ移動し、`examples` を参考に入力変数を用意。
2. `terraform init && terraform plan` で差分確認。
3. `terraform apply` で適用。

必要に応じて `wrappers/` 配下のラッパーモジュールで入力省略や既定値の適用が可能です。
