class PaymentMethod < ApplicationRecord
  has_many :payments
end

def process_paypal_payment
  details = EXPRESS_GATEWAY.details_for(params[:token])
  express_purchase_options =
    {
      ip: request.remote_ip,
      token: params[:token],
      payer_id: details.payer_id,
      currency: "USD"
    }

  price = details.params["order_total"].to_d * 100

  response = EXPRESS_GATEWAY.purchase(price, express_purchase_options)
  if response.success?
    payment = Payment.find_by(token: response.token)
    order = payment.order

    #update object states
    payment.state = "completed"
    order.state = "completed"

    ActiveRecord::Base.transaction do
      order.save!
      payment.save!
    end
  end
end