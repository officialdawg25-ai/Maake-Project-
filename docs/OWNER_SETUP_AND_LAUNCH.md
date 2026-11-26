# Maake Enterprise owner and launch checklist

## Supabase owner account
1. Open the Maake Project in Supabase Auth and create the business owner's account.
2. Assign the trusted app metadata claim role=maake_admin using a trusted dashboard/admin environment. Do not set this in editable user metadata.
3. Refresh the owner's session after changing app metadata.
4. Sign in at the site's Business Centre and verify that the orders and enquiries tabs load.
5. Keep all admin access restricted to people authorised by the business owner.

## Confirm business information
Collect and approve:
- Exact business name treatment and logo, if an existing logo exists.
- Business phone and WhatsApp number, business email and public location/map pin.
- Opening days and times, public holiday exceptions and temporary closure process.
- Final food menu, exact descriptions, approved product photographs, ZAR prices and stock availability.
- Collection instructions, delivery zones, delivery fees and minimum order if any.
- Catering packages, quote requirements and event lead time.
- Equipment inventory, hire periods, rates, deposits, delivery/collection terms, setup and breakdown responsibility.
- Mobile toilet and freezer capacity/specifications.
- Jumping castle sizes and safety/operating requirements.
- Taxi route origins/destinations, route days, departure times, fares, passenger limits and private-hire coverage.

## Before accepting real orders
- Replace or unpublish all sample products and prices until the owner approves them.
- Confirm delivery and collection operations.
- Add CAPTCHA or rate limiting to public order and enquiry submissions.
- Confirm who receives incoming requests and the response-time process.
- Test public access using a signed-out browser and confirm orders, order items and enquiries cannot be read.
- Test owner access using the authorised account and confirm status changes persist.
- Configure transactional email/WhatsApp only after sender identity and recipient details are verified.
- Select and test a payment provider before representing online payments as available.
- Do not convert hire enquiries into confirmed reservations until asset inventory and date-overlap protection are implemented.
- Do not advertise taxi bookings as confirmed until the operator has confirmed capacity and dispatch process.

## Launch gate
Launch only after the business owner approves the content and prices, an end-to-end order and enquiry test passes, RLS checks pass, the production build is green, and hosting/environment variables are configured.