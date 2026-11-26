# Maake Enterprise — comprehensive implementation brief

Act as the senior product engineer, UX architect and security-conscious full-stack developer completing Maake Enterprise in this repository.

## Business context
Maake Enterprise is a multi-service South African small business serving Maphalle and surrounding areas in Limpopo. Its offerings are:
- Food and catering: Kota, Bunny Chow, fast-food meals and catering.
- Taxi transport: scheduled routes and private transport bookings.
- Event and equipment services: mobile toilets, mobile freezer hire, jumping castles, tents and event equipment.

This is one enterprise with distinct customer journeys. Do not reduce it to a generic restaurant website.

## Product objective
Build a premium, mobile-first digital business platform that helps customers discover the business, browse food and prices, place orders, enquire about catering/equipment, and request transport. Give the owner a secure management centre to receive and manage orders and enquiries.

## Brand and visual direction
- Brand: MAAKE. ENTERPRISE.
- Positioning: Food. Transport. Events. Solutions.
- Service area: Maphalle and surrounding areas.
- Visual language: premium editorial, contemporary, warm, restrained and locally grounded.
- Palette: deep charcoal, warm ivory, stone and restrained copper/amber accent.
- Strong typography, generous whitespace, full-bleed photography and disciplined grids.
- Use subtle cinematic scroll reveals and parallax only where they improve storytelling.
- Avoid generic SaaS dashboards, noisy cards, excessive gradients, heavy shadows, fake testimonials, invented awards, invented customer counts and fake trust claims.
- Mobile-first and performant on lower-end Android devices and slower connections. Respect reduced-motion preferences and lazy-load imagery.

## Required public experiences
1. Homepage with cinematic hero, brand introduction and clear entry points for Food & Catering, Transport, and Events & Equipment.
2. Food menu with categories, product images, descriptions, ZAR pricing, availability and add-to-basket.
3. Basket and checkout with customer name, contact number, collection/delivery choice, delivery address when required, notes, clear subtotal and order submission.
4. Service catalogue for catering, mobile toilets, mobile freezer, jumping castles, tents and equipment hire. Each service has a structured enquiry form with date, location, guest count and details where applicable.
5. Transport page with separate scheduled-route enquiry and private-hire flows. Capture pickup, destination, date, preferred time and passenger count. Do not invent route schedules or fares.
6. Business information: operating hours, contact channels, service area, delivery/collection policy and location. Unknown details must be labelled pending confirmation, not invented.
7. Owner sign-in and private business centre.

## Owner management centre
- Supabase Auth email/password sign-in.
- Authorization enforced in database RLS using trusted app_metadata role maake_admin, never user-editable user_metadata.
- Order inbox with status updates: pending, accepted, preparing, ready, completed, cancelled.
- Order detail with customer contact, fulfilment, items, quantity, total and notes.
- Service enquiry inbox with statuses new, reviewing, quoted, confirmed, completed, declined.
- Transport enquiry inbox with equivalent status management.
- Product CRUD, availability and publish controls.
- Service catalogue management.
- Business hours and contact details management.
- Route management, only showing owner-confirmed routes.
- Reporting calculated from actual persisted records. Never seed fake sales or dashboard metrics.

## Data and backend
Use the existing Maake Supabase project. Inspect schema before changes. Do not create duplicate auth, order, customer or product systems.
Use the migration in supabase/migrations as source of truth.
Tables: business_profile, products, services, business_hours, transport_routes, orders, order_items, service_enquiries, transport_enquiries.
Use numeric ZAR prices. Order totals must be calculated server-side from trusted current product prices, never trusted from browser values.
Public visitors may read only published/available products, active services, public business profile, hours and active routes.
Public visitors may submit only validated order/service/transport requests. Never grant public access to read orders, customer PII or owner enquiries.
Owner access must be RLS-protected and based on auth.jwt()->'app_metadata'->>'role' = 'maake_admin'. Do not use SECURITY DEFINER casually. Any exposed SECURITY DEFINER RPC must validate all input, have a fixed search_path, narrow purpose, and explicit EXECUTE grants/revokes.
Never expose service_role or secret keys in frontend code. Use only the Supabase publishable/anon key in VITE_ environment variables.
Add rate limiting / anti-spam controls to public submission endpoints before production. Consider CAPTCHA or edge-function throttling.

## Operational correctness
- Avoid double-booking the same hire asset for overlapping dates. Before confirmed reservations, implement an asset inventory and transactional availability check. Until then, call them enquiries, not confirmed bookings.
- Scheduled taxi routes are not bookable until the owner enters route, fare, days and departure data.
- Delivery fees and delivery coverage are owner-configured; do not invent them.
- Payments are not integrated unless a real provider flow is implemented and verified. Do not label unpaid requests as paid.
- WhatsApp notification integration is a later phase and requires a verified business number and approved message workflow.
- Seed products/prices are demo-only. Do not represent sample pricing as owner-approved. Use is_demo and an unpublished/approval state; production launch requires approval.

## Engineering standards
- Inspect current repo and preserve existing working behaviour.
- Use React + Vite, Supabase JS, accessible semantic HTML and responsive CSS.
- Pin dependencies and commit lockfile.
- Separate data access, UI and forms.
- Validate and normalize all user input; show clear loading, success and error states.
- Use realtime only if justified and properly scoped.
- Add tests for order price calculation, form validation, RLS assumptions and booking overlap once inventory exists.
- Keep secrets out of git. Add .env.example with placeholders only.
- Add README with local setup, environment variables, migrations, owner provisioning, deployment and test instructions.

## Definition of done
1. npm install and npm run build pass.
2. Test mobile and desktop layouts, including narrow Android widths.
3. Verify customer can browse, add products, submit an order, and owner sees it after signing in.
4. Verify public role cannot read orders or customer enquiries.
5. Verify owner can update statuses and catalogue data.
6. Verify transport and service enquiries persist.
7. Verify no invented route schedules, opening hours, contact details, testimonials or business claims.
8. Run Supabase security/performance advisors and resolve actionable issues.
9. Inspect browser console and network requests; verify no secret keys or PII leak to public pages.
10. Report each item as VERIFIED, PARTIAL, INFERRED or BLOCKED. Never claim tests, deployments or notifications that were not actually run.

Implement in small, reviewable commits. Do not force-push, rewrite history, delete existing data or deploy to production without explicit authorization.
