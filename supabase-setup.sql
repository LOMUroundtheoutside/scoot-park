-- Scoot Park: online accounts + leaderboard.
-- Paste this whole file into Supabase > SQL Editor and press Run. Safe to run again.

create table if not exists public.players (
  id          uuid primary key references auth.users(id) on delete cascade,
  username    text not null check (username ~ '^[A-Za-z0-9_]{3,16}$'),
  total_score bigint not null default 0 check (total_score between 0 and 2000000000),
  best_combo  bigint not null default 0 check (best_combo between 0 and 200000000),
  challenges  integer not null default 0 check (challenges between 0 and 200),
  progress    jsonb not null default '{}'::jsonb,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create unique index if not exists players_username_unique on public.players (lower(username));
create index if not exists players_total_score on public.players (total_score desc);
create index if not exists players_best_combo on public.players (best_combo desc);

alter table public.players enable row level security;

-- Everyone can read the leaderboard.
drop policy if exists "Anyone can see the leaderboard" on public.players;
create policy "Anyone can see the leaderboard" on public.players
  for select using (true);

-- Logged-in players can only create and change their own row.
drop policy if exists "Players add their own row" on public.players;
create policy "Players add their own row" on public.players
  for insert to authenticated with check (auth.uid() = id);

drop policy if exists "Players update their own row" on public.players;
create policy "Players update their own row" on public.players
  for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

-- Let the website read the board and let logged-in players save (works even if
-- "Automatically expose new tables" was switched off when the project was made).
grant select on public.players to anon, authenticated;
grant insert, update on public.players to authenticated;
