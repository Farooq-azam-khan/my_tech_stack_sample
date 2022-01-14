alter table "public"."todo" add column "created_at" timestamptz
 null default now();
