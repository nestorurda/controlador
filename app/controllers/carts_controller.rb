class CartsController < ApplicationController
  before_action :authenticate_user!

  def update
    product = params[:cart][:product_id]
    quantity = params[:cart][:quantity]

    current_order.add_product(product, quantity)

    redirect_to root_url, notice: "Product added successfuly"
  end

  def show
    @order = current_order
  end 

  def payment_method
  Payment.pay_with_paypal
  end  

  def payment
  Payment_method.process_paypal_payment
  end

end
