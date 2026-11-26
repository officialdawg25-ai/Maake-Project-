# Maake Enterprise

A mobile-first digital storefront and operations workspace for Maake Enterprise, serving Maphalle and surrounding areas in Limpopo.

## Business divisions
- Food and catering: Kota, Bunny Chow, fast-food menu and catering enquiries.
- Transport: scheduled-route enquiries and private transport requests.
- Events and equipment: mobile toilets, mobile freezer, jumping castles, tents and event equipment.

## Stack
React 19, Vite 7, GSAP ScrollTrigger, Supabase JS and Supabase Postgres.

## Current implementation
- Premium editorial storefront with responsive home, food, services, transport and story pages.
- Menu, basket and checkout request flow.
- Service and transport enquiry forms.
- Owner sign-in, order inbox and order status updates.
- Supabase schema, RLS policies and order submission RPC.
- Sample catalogue explicitly marked as illustrative.

## Local setup
1. Install Node.js 20.19+ or 22.12+.
2. Run npm install.
3. Copy .env.example to .env.local.
4. Set VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY to the Maake project URL and publishable/anon key.
5. Run npm run dev.
6. Run npm run build before deployment.

Do not place Supabase service-role or secret keys in Vite environment variables. VITE_ values are public browser values.

## Supabase
Project ref: yaklqdynazovunrimjoa.

Migrations:
- supabase/migrations/202611260001_maake_enterprise_core.sql
- supabase/migrations/202611260002_maake_harden_policies_and_indexes.sql

The migrations create business profile, product, service, business hours, transport route, order, order item, service enquiry and transport enquiry tables. RLS is enabled on every exposed table. Public visitors can read only public catalogue/profile data and submit new requests; they cannot read orders, customer PII or owner enquiries.

Order totals are calculated by the database using current published product prices. The narrow public order RPC is SECURITY DEFINER by necessity because anonymous customers cannot insert directly into private order tables. It has a fixed search_path, validates input, reads trusted prices, and is executable only by anon. Its security-advisor warning is therefore an intentional public order-intake surface; it still requires abuse controls before production.

## Owner provisioning
The admin UI requires a Supabase Auth user with trusted app metadata:
{ "role": "maake_admin" }.
Set this only through a trusted Supabase admin environment (dashboard/server-side Admin API), never from client-side user metadata. Refresh the user's session after role assignment.

## Important launch blockers
- Product names, photos, descriptions and prices are demonstration content until approved by the owner.
- Opening hours, business phone, WhatsApp, email and precise address are not yet supplied.
- Taxi route origins, destinations, days, times, capacity and fares are not yet confirmed.
- Delivery coverage and delivery fee are not configured.
- Hire service prices, inventory and date-based availability are not yet configured.
- Payment provider and WhatsApp notification integration are not configured.
- Public forms need rate limiting/CAPTCHA before public launch.
- Owner product/service/hour/route editing UI is not yet complete.

## Security
- Only the Supabase publishable/anon key belongs in the browser.
- Owner access uses trusted app_metadata.role = maake_admin.
- Public visitors cannot select orders, order items or enquiry records.
- Never commit secrets or service-role keys.

## Build
Run npm install then npm run build. The repository currently needs a generated package lockfile before npm ci can be used in CI.
See docs/IMPLEMENTATION_PROMPT.md for the complete product brief and definition of done.
