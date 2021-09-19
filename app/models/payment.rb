class Payment < ApplicationRecord
  belongs_to :order
  belongs_to :payment_method
end

def pay_with_paypal
  order = Order.find(params[:cart][:order_id])

  #price must be in cents
  price = order.total * 100

  response = EXPRESS_GATEWAY.setup_purchase(price,
    ip: request.remote_ip,
    return_url: process_paypal_payment_cart_url,
    cancel_return_url: root_url,
    allow_guest_checkout: true,
    currency: "USD"
  )

  payment_method = PaymentMethod.find_by(code: "PEC")
  Payment.create(
    order_id: order.id,
    payment_method_id: payment_method.id,
    state: "processing",
    total: order.total,
    token: response.token
  )

  redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
end