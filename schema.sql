-- Four Hats: database setup
-- Run once in Supabase: Dashboard -> SQL Editor -> New query -> paste -> Run.
-- Safe to re-run.

create table if not exists public.fh_tasks (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid() references auth.users(id) on delete cascade,
  title       text not null check (char_length(title) between 1 and 300),
  hat         text check (hat in ('bishop', 'youth', 'family', 'work')),  -- null = Inbox
  step        text not null default '' check (char_length(step) <= 200), -- smallest first step
  done        boolean not null default false,
  done_at     timestamptz,
  today_date  date,                                                      -- set = picked for that day's 3
  today_pos   smallint check (today_pos between 0 and 2),
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index if not exists fh_tasks_user_idx on public.fh_tasks (user_id, done);

-- Keep updated_at current
create or replace function public.fh_touch_updated_at()
returns trigger language plpgsql set search_path = '' as $$
begin
  new.updated_at := now();
  return new;
end $$;

drop trigger if exists fh_tasks_touch on public.fh_tasks;
create trigger fh_tasks_touch before update on public.fh_tasks
  for each row execute function public.fh_touch_updated_at();

-- Row level security: each signed-in person sees and changes only their own tasks
alter table public.fh_tasks enable row level security;

drop policy if exists "fh_tasks_select_own" on public.fh_tasks;
drop policy if exists "fh_tasks_insert_own" on public.fh_tasks;
drop policy if exists "fh_tasks_update_own" on public.fh_tasks;
drop policy if exists "fh_tasks_delete_own" on public.fh_tasks;

create policy "fh_tasks_select_own" on public.fh_tasks
  for select to authenticated using ((select auth.uid()) = user_id);
create policy "fh_tasks_insert_own" on public.fh_tasks
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "fh_tasks_update_own" on public.fh_tasks
  for update to authenticated using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "fh_tasks_delete_own" on public.fh_tasks
  for delete to authenticated using ((select auth.uid()) = user_id);

revoke all on public.fh_tasks from anon;
grant select, insert, update, delete on public.fh_tasks to authenticated;
