class OrdersPage < SitePrism::Page
  set_url '/orders'
  set_url_matcher /\/orders$/

  section :header, HeaderSection, 'header'

  elements :orders, '#orders tbody tr'
end

def view_latest_orders
  stub_get to: Order.url, returns: orders_response

  site.orders.load
end

def assert_latest_orders_displayed
  site.orders.displayed?.must_equal true

  site.orders.header.menu_orders.present?.must_equal true
  site.orders.header.banner_title.text.must_equal 'Orders'

  site.orders.orders.count.must_equal 4
end

private

def orders_response
  [
    {
      id: 1,
      partner: 'alpha',
      order_number: 'ABCD123',
      total_price:  70.00,
      fee: 0.00,
      ordered_at: '2015-02-04T00:00:00Z',
      status: 'complete',
      currency_code: 'USD',
      order_details: [
        {
          type:   'domain_create',
          price:  70.00,
          domain: 'test.ph',
          period: 2,
          registrant_handle: 'domains_registrant',
          registered_at: '2015-02-04T00:00:00Z'
        }
      ]
    },
    {
      id: 2,
      partner: 'alpha',
      order_number: 'ABCD124',
      total_price: 35.00,
      fee: 0.00,
      ordered_at: '2015-02-27T14:00:00Z',
      status: 'complete',
      currency_code: 'USD',
      order_details: [
        {
          type: 'domain_renew',
          price: 35.00,
          domain: 'test.ph',
          period: 1,
          renewed_at: '2015-02-04T00:00:00Z'
        }
      ]
    },
    {
      id: 3,
      partner: 'alpha',
      order_number: 'ABCD125',
      total_price: 150.00,
      fee: 0.00,
      ordered_at: '2015-02-27T14:00:00Z',
      status: 'complete',
      currency_code: 'USD',
      order_details: [
        {
          type: 'credits',
          price: 150.00
        }
      ]
    },
    {
      id: 4,
      partner: 'alpha',
      order_number: 'ABCD126',
      total_price: 15.00,
      fee: 0.00,
      ordered_at: '2015-02-27T14:00:00Z',
      status: 'complete',
      currency_code: 'USD',
      order_details: [
        {
          type: 'domain_transfer',
          price: 15.00
        }
      ]
    }
  ]
end