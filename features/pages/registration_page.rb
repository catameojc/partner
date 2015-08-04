class RegistrationPage < SitePrism::Page
  set_url '/registration/search'
  set_url_matcher /\/domains$/

  element :head, '#head'
end

def search_domain
  Timecop.freeze Time.local(2015)

  stub_partner
  stub_create_contact
  stub_registration

  fill_in 'name', with: 'domain.ph'
  click_on 'Register new domain'
end

def domain_exists
  stub_request(:get, "http://test.host/domains?search=domain.ph").
    with(:headers => {'Accept'=>'application/json', 'Authorization'=>'Token token=abcd123456', 'Content-Type'=>'application/json'}).
    to_return(:status => 200, :body => search_domain_response.to_json, :headers => {})
end

def domain_does_not_exist
  stub_request(:get, "http://test.host/domains?search=domain.ph").
    with(:headers => {'Accept'=>'application/json', 'Authorization'=>'Token token=abcd123456', 'Content-Type'=>'application/json'}).
    to_return(:status => 200, :body => not_found_response.to_json, :headers => {})
end

def create_contact
  fill_in 'contact[handle]', with: 'contact'
  fill_in 'contact[name]', with: 'Contact Contactson'
  fill_in 'contact[organization]', with: 'Contacts R Us'
  fill_in 'contact[street]', with: '123 Contact St.'
  fill_in 'contact[city]', with: 'Contactville'
  first('select').find(:xpath, 'option[2]').select_option
  fill_in 'contact[voice]', with: '+63.2000000'
  fill_in 'contact[email]', with: 'contact@test.fake'

  click_on 'Update'
end

def should_be_on_create_contact_page
  assert page.has_content? 'Creating contact for order for domain.ph'
end

def stub_partner
      stub_request(:get, "http://test.host/user/partner").
        with(:headers => {'Accept'=>'application/json', 'Authorization'=>'Token token=abcd123456', 'Content-Type'=>'application/json'}).
        to_return(:status => 200, :body => partner.to_json, :headers => {})
end

def stub_create_contact
  stub_request(:post, "http://test.host/contacts").
        with(:body => "{\"errors\":{},\"handle\":\"contact\",\"name\":\"Contact Contactson\",\"local_name\":\"\",\"organization\":\"Contacts R Us\",\"local_organization\":\"\",\"street\":\"123 Contact St.\",\"local_street\":\"\",\"street2\":\"\",\"local_street2\":\"\",\"street3\":\"\",\"local_street3\":\"\",\"city\":\"Contactville\",\"local_city\":\"\",\"state\":\"\",\"local_state\":\"\",\"postal_code\":\"\",\"local_postal_code\":\"\",\"country_code\":\"PH\",\"local_country_code\":\"\",\"voice\":\"+63.2000000\",\"voice_ext\":\"\",\"fax\":\"\",\"fax_ext\":\"\",\"email\":\"contact@test.fake\",\"validation_context\":null}",
             :headers => {'Accept'=>'application/json', 'Authorization'=>'Token token=abcd123456', 'Content-Type'=>'application/json'}).
        to_return(:status => 200, :body => contact.to_json, :headers => {})
end

def stub_registration
  stub_request(:post, "http://test.host/orders").
        with(:body => "{\"currency_code\":\"USD\",\"order_details\":[{\"type\":\"domain_create\",\"domain\":\"domain.ph\",\"authcode\":\"dummy-code\",\"period\":1,\"registrant_handle\":\"contact\",\"registered_at\":\"2015-01-01T00:00:00.000+08:00\",\"renewed_at\":null}]}",
             :headers => {'Accept'=>'application/json', 'Authorization'=>'Token token=abcd123456', 'Content-Type'=>'application/json'}).
        to_return(:status => 200, :body => 
        {
          type: 'domain_create',
          price:  35.00,
          domain: 'domain.ph',
          object: nil,
          period: 1,
          registered_at: '2015-02-14T01:01:00Z'
        }.to_json, 
        :headers => {})
end

def search_domain_response
  [{
    id: 1,
    name: 'domain.ph',
    expires_at: DateTime.now,
    expired: false,
    registrant: {
      name: 'Registrant'
    }
  }]
end

def not_found_response
  []
end

def partner
  {
    id: 1,
    name: 'alpha',
    organization: 'Alpha Partner',
    credits: 1000.00,
    local: true,
    admin: false
  }
end

def contact
    {"handle":"alpha","name":"alpha","organization":nil,"street":nil,"street2":nil,"street3":nil,"city":nil,"state":nil,"postal_code":nil,"country_code":nil,"local_name":nil,"local_organization":nil,"local_street":nil,"local_street2":nil,"local_street3":nil,"local_city":nil,"local_state":nil,"local_postal_code":nil,"local_country_code":nil,"voice":nil,"voice_ext":nil,"fax":nil,"fax_ext":nil,"email":nil}
end