alter table public.products
  add column if not exists ingredients text[] not null default '{}';

update public.products set ingredients = array['Bread','Polony','Vienna','Cheese','Atchar','Signature sauce','Golden chips']
where slug='classic-kota' and cardinality(ingredients)=0;
update public.products set ingredients = array['Bread','Polony','Vienna','Cheese','Atchar','Signature sauce','Golden chips','Fresh lettuce']
where slug='signature-kota' and cardinality(ingredients)=0;
update public.products set ingredients = array['Bread','Polony','Vienna','Russian','Cheese','Atchar','Signature sauce','Golden chips','Fresh lettuce']
where slug='loaded-kota' and cardinality(ingredients)=0;
update public.products set ingredients = array['Bread','Polony','Vienna','Russian','Cheese','Atchar','Signature sauce','Golden chips','Fresh lettuce','Extra filling']
where slug='deluxe-kota' and cardinality(ingredients)=0;
update public.products set ingredients = array['Bread','Polony','Vienna','Russian','Cheese','Atchar','Signature sauce','Golden chips','Fresh lettuce','Generous extra filling']
where slug='ultimate-kota' and cardinality(ingredients)=0;