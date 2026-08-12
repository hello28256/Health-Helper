-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL,
    "email" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "display_name" TEXT,
    "height_cm" DECIMAL(5,2),
    "weight_kg" DECIMAL(5,2),
    "birth_date" DATE,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "refresh_tokens" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "device_id" TEXT NOT NULL,
    "token_hash" TEXT NOT NULL,
    "expires_at" TIMESTAMPTZ NOT NULL,
    "revoked_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "refresh_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "exercise_types" (
    "id" TEXT NOT NULL,
    "display_name_zh" TEXT NOT NULL,
    "display_name_en" TEXT NOT NULL,
    "met" DECIMAL(4,2) NOT NULL,
    "notes" TEXT,
    "icon_key" TEXT,

    CONSTRAINT "exercise_types_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "exercise_records" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "type_id" TEXT NOT NULL,
    "started_at" TIMESTAMPTZ NOT NULL,
    "duration_sec" INTEGER NOT NULL,
    "distance_km" DECIMAL(6,2),
    "calories" DECIMAL(7,2) NOT NULL,
    "client_id" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "exercise_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "daily_steps" (
    "user_id" UUID NOT NULL,
    "date" DATE NOT NULL,
    "steps" INTEGER NOT NULL,
    "source" TEXT,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "daily_steps_pkey" PRIMARY KEY ("user_id","date")
);

-- CreateTable
CREATE TABLE "food_nutrients" (
    "id" BIGSERIAL NOT NULL,
    "source" TEXT NOT NULL,
    "external_id" TEXT,
    "name" TEXT NOT NULL,
    "name_zh" TEXT,
    "category" TEXT,
    "serving_size_g" DECIMAL(8,2),
    "kcal_per_100g" DECIMAL(7,2),
    "protein_g" DECIMAL(6,2),
    "fat_g" DECIMAL(6,2),
    "carbs_g" DECIMAL(6,2),
    "fiber_g" DECIMAL(6,2),
    "sodium_mg" DECIMAL(8,2),
    "extra" JSONB,

    CONSTRAINT "food_nutrients_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "diet_records" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "food_id" BIGINT NOT NULL,
    "meal_type" TEXT NOT NULL,
    "consumed_at" TIMESTAMPTZ NOT NULL,
    "servings" DECIMAL(5,2) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "diet_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mood_records" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "mood" TEXT NOT NULL,
    "score" INTEGER,
    "note" TEXT,
    "recorded_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "mood_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "chat_logs" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "role" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "chat_logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "refresh_tokens_token_hash_key" ON "refresh_tokens"("token_hash");

-- CreateIndex
CREATE INDEX "refresh_tokens_user_id_idx" ON "refresh_tokens"("user_id");

-- CreateIndex
CREATE INDEX "refresh_tokens_device_id_idx" ON "refresh_tokens"("device_id");

-- CreateIndex
CREATE INDEX "exercise_records_user_id_started_at_idx" ON "exercise_records"("user_id", "started_at");

-- CreateIndex
CREATE UNIQUE INDEX "exercise_records_user_id_client_id_key" ON "exercise_records"("user_id", "client_id");

-- CreateIndex
CREATE INDEX "daily_steps_user_id_date_idx" ON "daily_steps"("user_id", "date");

-- CreateIndex
CREATE INDEX "food_nutrients_source_external_id_idx" ON "food_nutrients"("source", "external_id");

-- CreateIndex
CREATE INDEX "food_nutrients_name_idx" ON "food_nutrients"("name");

-- CreateIndex
CREATE INDEX "diet_records_user_id_consumed_at_idx" ON "diet_records"("user_id", "consumed_at");

-- CreateIndex
CREATE INDEX "mood_records_user_id_recorded_at_idx" ON "mood_records"("user_id", "recorded_at");

-- CreateIndex
CREATE INDEX "chat_logs_user_id_created_at_idx" ON "chat_logs"("user_id", "created_at");

-- AddForeignKey
ALTER TABLE "refresh_tokens" ADD CONSTRAINT "refresh_tokens_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exercise_records" ADD CONSTRAINT "exercise_records_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exercise_records" ADD CONSTRAINT "exercise_records_type_id_fkey" FOREIGN KEY ("type_id") REFERENCES "exercise_types"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "daily_steps" ADD CONSTRAINT "daily_steps_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "diet_records" ADD CONSTRAINT "diet_records_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "diet_records" ADD CONSTRAINT "diet_records_food_id_fkey" FOREIGN KEY ("food_id") REFERENCES "food_nutrients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mood_records" ADD CONSTRAINT "mood_records_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chat_logs" ADD CONSTRAINT "chat_logs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
