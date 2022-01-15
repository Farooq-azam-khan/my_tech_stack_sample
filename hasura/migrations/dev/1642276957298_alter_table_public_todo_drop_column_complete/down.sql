alter table "public"."todo" alter column "complete" set default false;
alter table "public"."todo" alter column "complete" drop not null;
alter table "public"."todo" add column "complete" bool;
