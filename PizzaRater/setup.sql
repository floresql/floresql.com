-- Run this in Supabase: Database → SQL Editor → New query

create table places (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  created_at timestamptz default now()
);

create table ratings (
  id uuid default gen_random_uuid() primary key,
  place_id uuid references places(id) on delete cascade not null,
  voter_id text not null,
  rating int not null check (rating between 1 and 5),
  created_at timestamptz default now(),
  unique(place_id, voter_id)
);

alter table places enable row level security;
alter table ratings enable row level security;

-- Places: anyone can read, only logged-in admin can add/delete
create policy "Public read places"   on places for select using (true);
create policy "Admin insert places"  on places for insert to authenticated with check (true);
create policy "Admin delete places"  on places for delete to authenticated using (true);

-- Ratings: anyone can read and submit (voter_id UUID makes abuse impractical)
create policy "Public read ratings"   on ratings for select using (true);
create policy "Public insert ratings" on ratings for insert with check (true);
create policy "Public update ratings" on ratings for update using (true);
