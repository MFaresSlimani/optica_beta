-- ==============================================================================
-- BNG Optica - Supabase Database & Storage Setup Schema
-- Run this complete script in the Supabase Dashboard -> SQL Editor
-- ==============================================================================

-- 1. Create Users Table
create table if not exists public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null default '',
  username text not null default '',
  phone_number text not null default '',
  pfp text not null default '',
  is_store_owner boolean not null default false,
  is_restricted boolean not null default false,
  store_id text default '',
  fcmtoken text default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 2. Create Stores Table
create table if not exists public.stores (
  id uuid primary key default gen_random_uuid(),
  store_name text not null,
  store_details text not null default '',
  store_location text not null default '',
  store_owner text not null default '',
  store_owner_email text not null default '',
  store_owner_uid uuid not null references public.users(id) on delete cascade,
  store_owner_pfp text not null default '',
  store_owner_phone_number text not null default '',
  is_restricted boolean not null default false,
  is_approved boolean not null default true,
  store_admins jsonb not null default '[]'::jsonb,
  store_pictures jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now()
);

-- 3. Create Requests Table
create table if not exists public.requests (
  id uuid primary key default gen_random_uuid(),
  sender_uid uuid not null references public.users(id) on delete cascade,
  receiver_uid uuid not null references public.users(id) on delete cascade,
  store_id text not null,
  description jsonb not null default '[]'::jsonb,
  done_glasses jsonb not null default '[]'::jsonb,
  left_glasses jsonb not null default '[]'::jsonb,
  created_at bigint not null,
  done_at bigint,
  done_message text not null default '',
  is_done boolean not null default false
);

-- 4. Enable Row Level Security (RLS)
alter table public.users enable row level security;
alter table public.stores enable row level security;
alter table public.requests enable row level security;

-- 5. RLS Policies for Users
create policy "Public profiles are readable by everyone"
  on public.users for select
  using (true);

create policy "Users can insert their own profile"
  on public.users for insert
  with check (auth.uid() = id);

create policy "Users can update their own profile"
  on public.users for update
  using (auth.uid() = id);

-- 6. RLS Policies for Stores
create policy "Approved stores or own stores are readable by all authenticated users"
  on public.stores for select
  using (is_approved = true or auth.uid() = store_owner_uid);

create policy "Authenticated users can create stores"
  on public.stores for insert
  with check (auth.uid() = store_owner_uid);

create policy "Store owners can update their store"
  on public.stores for update
  using (auth.uid() = store_owner_uid);

create policy "Store owners can delete their store"
  on public.stores for delete
  using (auth.uid() = store_owner_uid);

-- 7. RLS Policies for Requests
create policy "Participants can read their own requests"
  on public.requests for select
  using (auth.uid() = sender_uid or auth.uid() = receiver_uid);

create policy "Buyers can create requests"
  on public.requests for insert
  with check (auth.uid() = sender_uid);

create policy "Participants can update their requests"
  on public.requests for update
  using (auth.uid() = sender_uid or auth.uid() = receiver_uid);

-- 8. Auto-create User Profile on Sign Up via Auth Trigger
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.users (id, email, username)
  values (
    new.id,
    coalesce(new.email, ''),
    coalesce(new.raw_user_meta_data->>'username', '')
  )
  on conflict (id) do update set
    email = excluded.email;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- 9. Enable Realtime on Tables
alter publication supabase_realtime add table public.requests;
alter publication supabase_realtime add table public.users;
alter publication supabase_realtime add table public.stores;

-- 10. Storage Buckets Setup
insert into storage.buckets (id, name, public)
values ('profiles', 'profiles', true)
on conflict (id) do update set public = true;

insert into storage.buckets (id, name, public)
values ('stores', 'stores', true)
on conflict (id) do update set public = true;

-- Storage RLS Policies
create policy "Public Access to Profiles"
  on storage.objects for select
  using (bucket_id = 'profiles');

create policy "Authenticated users can upload to profiles"
  on storage.objects for insert
  with check (bucket_id = 'profiles' and auth.role() = 'authenticated');

create policy "Authenticated users can update profiles"
  on storage.objects for update
  using (bucket_id = 'profiles' and auth.role() = 'authenticated');

create policy "Public Access to Stores"
  on storage.objects for select
  using (bucket_id = 'stores');

create policy "Authenticated users can upload to stores"
  on storage.objects for insert
  with check (bucket_id = 'stores' and auth.role() = 'authenticated');

create policy "Authenticated users can update stores"
  on storage.objects for update
  using (bucket_id = 'stores' and auth.role() = 'authenticated');
