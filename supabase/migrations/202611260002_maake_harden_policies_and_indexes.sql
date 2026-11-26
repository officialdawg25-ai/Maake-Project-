-- Follow-up hardening for both the live project and clean migration installs.
alter table public.business_profile add column if not exists order_notice text not null default 'Demo catalogue. Confirm menu, prices and availability with the business.';

-- Remove the original baseline policy names as well as the live-project names before recreating a single policy per role/action.
drop policy if exists business_profile_public_read on public.business_profile;
drop policy if exists business_profile_admin on public.business_profile;
drop policy if exists products_public_read on public.products;
drop policy if exists products_admin on public.products;
drop policy if exists services_public_read on public.services;
drop policy if exists services_admin on public.services;
drop policy if exists hours_public_read on public.business_hours;
drop policy if exists hours_admin on public.business_hours;
drop policy if exists routes_public_read on public.transport_routes;
drop policy if exists routes_admin on public.transport_routes;
drop policy if exists orders_admin on public.orders;
drop policy if exists items_admin on public.order_items;
drop policy if exists service_enquiry_public_insert on public.service_enquiries;
drop policy if exists service_enquiry_admin on public.service_enquiries;
drop policy if exists transport_enquiry_public_insert on public.transport_enquiries;
drop policy if exists transport_enquiry_admin on public.transport_enquiries;
drop policy if exists "Public can read business profile" on public.business_profile;
drop policy if exists "Public can read published products" on public.products;
drop policy if exists "Public can read active services" on public.services;
drop policy if exists "Public can read business hours" on public.business_hours;
drop policy if exists "Public can read active routes" on public.transport_routes;
drop policy if exists "Public can submit service enquiries" on public.service_enquiries;
drop policy if exists "Public can submit transport enquiries" on public.transport_enquiries;
drop policy if exists "Maake admins manage business profile" on public.business_profile;
drop policy if exists "Maake admins manage products" on public.products;
drop policy if exists "Maake admins manage services" on public.services;
drop policy if exists "Maake admins manage business hours" on public.business_hours;
drop policy if exists "Maake admins manage routes" on public.transport_routes;
drop policy if exists "Maake admins manage orders" on public.orders;
drop policy if exists "Maake admins manage order items" on public.order_items;
drop policy if exists "Maake admins manage service enquiries" on public.service_enquiries;
drop policy if exists "Maake admins manage transport enquiries" on public.transport_enquiries;

create policy "Public can read business profile" on public.business_profile for select to anon using (id = true);
create policy "Public can read published products" on public.products for select to anon using (is_published = true and is_available = true);
create policy "Public can read active services" on public.services for select to anon using (is_active = true);
create policy "Public can read business hours" on public.business_hours for select to anon using (true);
create policy "Public can read active routes" on public.transport_routes for select to anon using (is_active = true);
create policy "Public can submit service enquiries" on public.service_enquiries for insert to anon with check (status = 'new' and char_length(trim(customer_name)) between 2 and 100 and char_length(trim(customer_phone)) between 7 and 30);
create policy "Public can submit transport enquiries" on public.transport_enquiries for insert to anon with check (status = 'new' and char_length(trim(customer_name)) between 2 and 100 and char_length(trim(customer_phone)) between 7 and 30);

create policy "Maake admins manage business profile" on public.business_profile for all to authenticated
using (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'maake_admin') with check (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'maake_admin');
create policy "Maake admins manage products" on public.products for all to authenticated
using (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'maake_admin') with check (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'maake_admin');
create policy "Maake admins manage services" on public.services for all to authenticated
using (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'maake_admin') with check (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'maake_admin');
create policy "Maake admins manage business hours" on public.business_hours for all to authenticated
using (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'maake_admin') with check (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'maake_admin');
create policy "Maake admins manage routes" on public.transport_routes for all to authenticated
using (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'maake_admin') with check (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'maake_admin');
create policy "Maake admins manage orders" on public.orders for all to authenticated
using (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'maake_admin') with check (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'maake_admin');
create policy "Maake admins manage order items" on public.order_items for all to authenticated
using (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'maake_admin') with check (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'maake_admin');
create policy "Maake admins manage service enquiries" on public.service_enquiries for all to authenticated
using (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'maake_admin') with check (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'maake_admin');
create policy "Maake admins manage transport enquiries" on public.transport_enquiries for all to authenticated
using (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'maake_admin') with check (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'maake_admin');

create index if not exists order_items_product_id_idx on public.order_items(product_id);
create index if not exists service_enquiries_service_id_idx on public.service_enquiries(service_id);
create index if not exists transport_enquiries_route_id_idx on public.transport_enquiries(route_id);

revoke all on function public.submit_maake_order(text,text,text,text,text,jsonb) from public, authenticated;
grant execute on function public.submit_maake_order(text,text,text,text,text,jsonb) to anon;

do $$ begin
  if to_regprocedure('public.rls_auto_enable()') is not null then
    execute 'revoke all on function public.rls_auto_enable() from public, anon, authenticated';
  end if;
end $$;
