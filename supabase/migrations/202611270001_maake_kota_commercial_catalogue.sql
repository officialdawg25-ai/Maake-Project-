-- Publish the approved Maake Enterprise Kota range in the existing catalogue.
-- Preserve the existing Classic Kota record (and any order-item references).
-- Retire unverified demonstration-only menu entries without deleting their records.

update public.products
set slug = 'classic-kota',
    name = 'The Classic Kota',
    description = 'A South African kota, prepared fresh to order.',
    category = 'kota',
    price = 15.00,
    is_published = true,
    is_available = true,
    is_demo = false,
    sort_order = 10,
    updated_at = now()
where slug = 'classic-kota-demo';

insert into public.products
  (slug, name, description, category, price, is_published, is_available, is_demo, sort_order)
values
  ('classic-kota', 'The Classic Kota', 'A South African kota, prepared fresh to order.', 'kota', 15.00, true, true, false, 10)
on conflict (slug) do update set
  name = excluded.name,
  description = excluded.description,
  category = excluded.category,
  price = excluded.price,
  is_published = excluded.is_published,
  is_available = excluded.is_available,
  is_demo = excluded.is_demo,
  sort_order = excluded.sort_order,
  updated_at = now();

insert into public.products
  (slug, name, description, category, price, is_published, is_available, is_demo, sort_order)
values
  ('signature-kota', 'The Signature Kota', 'A signature Maake Kota option, prepared fresh to order.', 'kota', 20.00, true, true, false, 20),
  ('loaded-kota', 'The Loaded Kota', 'A generously prepared Maake Kota option.', 'kota', 25.00, true, true, false, 30),
  ('deluxe-kota', 'The Deluxe Kota', 'A deluxe Maake Kota option, prepared fresh to order.', 'kota', 30.00, true, true, false, 40),
  ('ultimate-kota', 'The Ultimate Kota', 'The top-tier Maake Kota option, prepared fresh to order.', 'kota', 40.00, true, true, false, 50)
on conflict (slug) do update set
  name = excluded.name,
  description = excluded.description,
  category = excluded.category,
  price = excluded.price,
  is_published = excluded.is_published,
  is_available = excluded.is_available,
  is_demo = excluded.is_demo,
  sort_order = excluded.sort_order,
  updated_at = now();

-- Keep unverified sample foods out of the customer-facing catalogue.
-- Their records remain intact for audit/history; existing orders are untouched.
update public.products
set is_published = false,
    updated_at = now()
where slug in ('bunny-chow-demo', 'chicken-and-chips-demo');
