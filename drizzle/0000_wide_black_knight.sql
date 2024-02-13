DO $$ BEGIN
 CREATE TYPE "aal_level" AS ENUM('aal1', 'aal2', 'aal3');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "code_challenge_method" AS ENUM('s256', 'plain');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "factor_status" AS ENUM('unverified', 'verified');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "factor_type" AS ENUM('totp', 'webauthn');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "key_status" AS ENUM('default', 'valid', 'invalid', 'expired');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "key_type" AS ENUM('aead-ietf', 'aead-det', 'hmacsha512', 'hmacsha256', 'auth', 'shorthash', 'generichash', 'kdf', 'secretbox', 'secretstream', 'stream_xchacha20');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "pricing_plan_interval" AS ENUM('day', 'week', 'month', 'year');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "pricing_type" AS ENUM('one_time', 'recurring');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "subscription_status" AS ENUM('trialing', 'active', 'canceled', 'incomplete', 'incomplete_expired', 'past_due', 'unpaid');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "customers" (
	"id" uuid PRIMARY KEY NOT NULL,
	"stripe_customer_id" text
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "inquiries" (
	"id" bigint PRIMARY KEY NOT NULL,
	"name" varchar(255),
	"email" varchar(255),
	"message" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "prices" (
	"id" text PRIMARY KEY NOT NULL,
	"product_id" text,
	"active" boolean,
	"description" text,
	"unit_amount" bigint,
	"currency" text,
	"type" "pricing_type",
	"interval" "pricing_plan_interval",
	"interval_count" integer,
	"trial_period_days" integer,
	"metadata" jsonb
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "products" (
	"id" text PRIMARY KEY NOT NULL,
	"active" boolean,
	"name" text,
	"description" text,
	"image" text,
	"metadata" jsonb
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "subscriptions" (
	"id" text PRIMARY KEY NOT NULL,
	"user_id" uuid NOT NULL,
	"status" "subscription_status",
	"metadata" jsonb,
	"price_id" text,
	"quantity" integer,
	"cancel_at_period_end" boolean,
	"created" timestamp with time zone DEFAULT now() NOT NULL,
	"current_period_start" timestamp with time zone DEFAULT now() NOT NULL,
	"current_period_end" timestamp with time zone DEFAULT now() NOT NULL,
	"ended_at" timestamp with time zone DEFAULT now() NOT NULL,
	"cancel_at" timestamp with time zone DEFAULT now() NOT NULL,
	"canceled_at" timestamp with time zone DEFAULT now() NOT NULL,
	"trial_start" timestamp with time zone DEFAULT now() NOT NULL,
	"trial_end" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "users" (
	"id" uuid PRIMARY KEY NOT NULL,
	"full_name" text,
	"avatar_url" text,
	"billing_address" jsonb,
	"payment_method" jsonb,
	"email" text,
	"updated_at" timestamp with time zone,
	"created_at" timestamp with time zone
);
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "customers" ADD CONSTRAINT "customers_id_users_id_fk" FOREIGN KEY ("id") REFERENCES "users"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "prices" ADD CONSTRAINT "prices_product_id_products_id_fk" FOREIGN KEY ("product_id") REFERENCES "products"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "subscriptions" ADD CONSTRAINT "subscriptions_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "subscriptions" ADD CONSTRAINT "subscriptions_price_id_prices_id_fk" FOREIGN KEY ("price_id") REFERENCES "prices"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "users" ADD CONSTRAINT "users_id_fkey" FOREIGN KEY ("id") REFERENCES "users"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
