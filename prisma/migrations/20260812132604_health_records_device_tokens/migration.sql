-- CreateEnum
CREATE TYPE "health_metric" AS ENUM ('steps', 'heart_rate', 'sleep', 'weight', 'blood_pressure', 'blood_glucose', 'spo2', 'body_temperature');

-- CreateEnum
CREATE TYPE "device_platform" AS ENUM ('ios', 'android', 'web');

-- CreateTable
CREATE TABLE "health_records" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "metric" "health_metric" NOT NULL,
    "value" DECIMAL(12,4) NOT NULL,
    "unit" VARCHAR(16) NOT NULL,
    "start_at" TIMESTAMPTZ NOT NULL,
    "end_at" TIMESTAMPTZ,
    "source" VARCHAR(64) NOT NULL,
    "raw" JSONB,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "health_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "device_tokens" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "device_id" TEXT NOT NULL,
    "platform" "device_platform" NOT NULL,
    "fcm_token" TEXT,
    "apns_token" TEXT,
    "app_version" VARCHAR(32),
    "locale" VARCHAR(16),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "last_seen_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "revoked_at" TIMESTAMPTZ,

    CONSTRAINT "device_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "health_records_user_id_metric_start_at_idx" ON "health_records"("user_id", "metric", "start_at");

-- CreateIndex
CREATE INDEX "device_tokens_user_id_revoked_at_idx" ON "device_tokens"("user_id", "revoked_at");

-- CreateIndex
CREATE UNIQUE INDEX "device_tokens_user_id_device_id_platform_key" ON "device_tokens"("user_id", "device_id", "platform");

-- AddForeignKey
ALTER TABLE "health_records" ADD CONSTRAINT "health_records_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "device_tokens" ADD CONSTRAINT "device_tokens_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
