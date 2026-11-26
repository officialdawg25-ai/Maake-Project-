-- Correct and harden the public order intake RPC.
create or replace function public.submit_maake_order(
  p_customer_name text,p_customer_phone text,p_fulfilment_method text,
  p_delivery_address text,p_customer_notes text,p_items jsonb
) returns uuid
language plpgsql security definer set search_path = ''
as $$
declare
  v_order_id uuid := pg_catalog.gen_random_uuid();
  v_order_number text;
  v_subtotal numeric(10,2) := 0;
  v_item jsonb;
  v_product_id uuid;
  v_product_name text;
  v_unit_price numeric(10,2);
  v_quantity integer;
begin
  if p_customer_name is null or pg_catalog.char_length(pg_catalog.btrim(p_customer_name)) not between 2 and 100 then raise exception 'Please provide a valid customer name'; end if;
  if p_customer_phone is null or pg_catalog.char_length(pg_catalog.btrim(p_customer_phone)) not between 7 and 30 then raise exception 'Please provide a valid contact number'; end if;
  if p_fulfilment_method is null or p_fulfilment_method not in ('collection','delivery') then raise exception 'Invalid fulfilment method'; end if;
  if p_fulfilment_method='delivery' and nullif(pg_catalog.btrim(p_delivery_address),'') is null then raise exception 'A delivery address is required'; end if;
  if p_items is null or pg_catalog.jsonb_typeof(p_items)<>'array' then raise exception 'Your basket must contain an item list'; end if;
  if pg_catalog.jsonb_array_length(p_items)<1 or pg_catalog.jsonb_array_length(p_items)>30 then raise exception 'Your basket is empty or contains too many items'; end if;
  v_order_number:='ME-'||pg_catalog.upper(pg_catalog.substr(pg_catalog.replace(v_order_id::text,'-',''),1,8));
  insert into public.orders(id,order_number,customer_name,customer_phone,fulfilment_method,delivery_address,customer_notes,subtotal,delivery_fee,total)
  values(v_order_id,v_order_number,pg_catalog.btrim(p_customer_name),pg_catalog.btrim(p_customer_phone),p_fulfilment_method,case when p_fulfilment_method='delivery' then pg_catalog.btrim(p_delivery_address) end,pg_catalog.left(coalesce(p_customer_notes,''),1000),0,0,0);
  for v_item in select value from pg_catalog.jsonb_array_elements(p_items) loop
    v_product_id:=(v_item->>'product_id')::uuid;
    v_quantity:=(v_item->>'quantity')::integer;
    if v_quantity is null or v_quantity<1 or v_quantity>30 then raise exception 'Invalid item quantity'; end if;
    select p.id,p.name,p.price into v_product_id,v_product_name,v_unit_price from public.products p where p.id=v_product_id and p.is_published=true and p.is_available=true;
    if not found then raise exception 'One or more products are no longer available'; end if;
    v_subtotal:=v_subtotal+(v_unit_price*v_quantity);
    insert into public.order_items(order_id,product_id,product_name,unit_price,quantity,line_total) values(v_order_id,v_product_id,v_product_name,v_unit_price,v_quantity,v_unit_price*v_quantity);
  end loop;
  update public.orders set subtotal=v_subtotal,total=v_subtotal,updated_at=pg_catalog.now() where id=v_order_id;
  return v_order_id;
end;
$$;
revoke all on function public.submit_maake_order(text,text,text,text,text,jsonb) from public,authenticated;
grant execute on function public.submit_maake_order(text,text,text,text,text,jsonb) to anon;
