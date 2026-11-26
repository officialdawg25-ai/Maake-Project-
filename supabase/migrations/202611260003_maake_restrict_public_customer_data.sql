-- Explicitly remove inherited/default public table access from private customer/order records.
revoke all on table public.orders, public.order_items, public.service_enquiries, public.transport_enquiries from public, anon;
grant select, update on table public.orders to authenticated;
grant select on table public.order_items to authenticated;
grant select, insert, update, delete on table public.service_enquiries, public.transport_enquiries to authenticated;
grant insert on table public.service_enquiries, public.transport_enquiries to anon;
