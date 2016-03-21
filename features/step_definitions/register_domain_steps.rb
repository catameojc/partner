When /^I try to register an available domain$/  do
  stub_get  to: User.partner_url,
            returns:  'partners/1/get_response'.json

  stub_get  to: Domain.url(params: { name: 'available.ph' }),
            returns: 'domains/available.ph/get_response'.json

  site.register.load

  site.register.domain_name.set 'available.ph'
  site.register.submit.click

  expect(site.register.details).to be_displayed
end

When /^I provide valid domain details$/ do
  stub_post to: Contact.url,
            with:     'contacts/post_request'.json,
            returns:  'contacts/post_response'.json

  stub_post to: Order.url,
            with:     'orders/post_register_domain_request'.json,
            returns:  'orders/post_register_domain_response'.json

  site.register.details.submit_valid_details
end

When /^I try to register an available domain in all caps$/  do
  stub_get  to: User.partner_url,
            returns:  'partners/1/get_response'.json

  stub_get  to: Domain.url(params: { name: 'available.ph' }),
            returns: 'domains/available.ph/get_response'.json

  stub_post to: Contact.url,
            with:     'contacts/post_request'.json,
            returns:  'contacts/post_response'.json

  stub_post to: Order.url,
            with:     'orders/post_register_domain_request'.json,
            returns:  'orders/post_register_domain_response'.json

  site.register.load

  site.register.domain_name.set 'AVAILABLE.PH'
  site.register.submit.click

  expect(site.register.details).to be_displayed

  site.register.details.submit_valid_details
end

When /^I try to register an existing domain$/  do
  stub_get  to: Domain.url(params: { name: 'existing.ph' }),
            returns: 'domains/existing.ph/get_response'.json

  site.register.load

  site.register.domain_name.set 'existing.ph'
  site.register.submit.click
end

When /^I try to provide the registrant without selecting a domain$/ do
  stub_get  to: User.partner_url,
            returns:  'partners/1/get_response'.json

  site.register.details.load
end

When /^I try to register an invalid domain$/ do
  site.register.load

  site.register.domain_name.set '123'
  site.register.submit.click
end

When /^I try to register a domain with invalid registrant info$/ do
  stub_get  to: User.partner_url,
            returns:  'partners/1/get_response'.json

  stub_get  to: Contact.url(id: '123456789ABCDEF'),
            returns:  404

  site.register.details.load domain_name: 'available.ph'

  site.register.details.local_name.set 'Name Only'
  site.register.details.submit.click
end

When /^I try to register a domain that was registered at the same time$/ do
  stub_get  to: User.partner_url,
            returns:  'partners/1/get_response'.json

  stub_post to: Contact.url,
            returns: 'contacts/post_response'.json

  stub_post to: Order.url,
            returns:  422

  stub_get  to: Contact.url(id: '123456789ABCDEF'),
            returns: 'contacts/123456789ABCDEF/get_response'.json

  site.register.details.load domain_name: 'conflict.ph'

  site.register.details.submit_valid_details
end

When /^I try to provide a registrant with existing handle$/ do
  stub_get  to: User.partner_url,
            returns:  'partners/1/get_response'.json

  stub_post to: Contact.url,
            returns:  422

  stub_get  to: Contact.url(id: '123456789ABCDEF'),
            returns: 404

  site.register.details.load domain_name: 'existing_handle.ph'

  site.register.details.submit_valid_details
end

Then /^domain must be registered$/  do
  expect(site.register).to be_displayed

  expect(site.register.notice.text).to eql 'Domain Registered'
end

Then /^I must be notified that domain is not available for registration$/  do
  expect(site.register).to be_displayed

  expect(site.register.alert.text).to eql 'Domain Not Available'
end

Then /^I must be first asked a domain to register$/ do
  expect(site.register).to be_displayed

  expect(site.register).not_to have_notice
  expect(site.register).not_to have_alert
end

Then /^I must be notified that domain is not valid$/ do
  expect(site.register).to be_displayed

  expect(site.register.alert.text).to eql 'Domain Not Valid'
end

Then /^I must be notified that the registrant info is not valid$/ do
  expect(site.register.details).to be_displayed

  expect(site.register.details).to have_warning

  expect(site.register.details.local_name.value).to eql 'Name Only'
end

Then /^I must be notified that domain is no longer available$/ do
  expect(site.register).to be_displayed

  expect(site.register.alert.text).to eql 'Domain Already Registered!'
end

Then /^I must be notified that the registrant already exists$/ do
  expect(site.register.details).to be_displayed

  expect(site.register.details).to have_warning
end
