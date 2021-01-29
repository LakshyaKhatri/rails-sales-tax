module Api
  module V1
    class CartController < Api::V1::ApiController
      def add_item
        create_cart unless current_cart.present?
        cart_item = CartItem.new(
          item_id: params[:item_id],
          qty: 1,
          cart: current_cart
        )

        render_record_invalid cart_item.errors unless cart_item.save
      end

      def remove_item
        #TODO: use current cart relation to get cart item instead
        if current_cart.present?
          cart_item = CartItem.find_by(
            item_id: params[:item_id],
            cart: current_cart
          )
          if cart_item.present?
            cart_item.delete
          else
            render_record_invalid "Item doesn't exists in cart"
          end
        else
          #TODO: could be removed
          render_record_invalid "Cart doesn't exists yet."
        end
      end

      def increase_qty
        #TODO: Handle db connection loss
        cart_item = CartItem.find_by(id: params[:cart_item_id])
        return render_record_invalid "Item doesn't exists in cart" unless cart_item.present?
        cart_item.qty += 1
        render_record_invalid cart_item.errors unless cart_item.save
      end

      def decrease_qty
        cart_item = CartItem.find_by(id: params[:cart_item_id])

        if cart_item.present?
          cart_item.qty -= 1
          render_record_invalid cart_item.errors unless cart_item.save
        else
          render_record_invalid "Item doesn't exists in cart"
        end
      end


      private
      def create_cart
        cart = Cart.new
        if cart.save
          session[:cart_id] = cart.id
        end
        #TODO: Do something if db connection is not established.
      end
    end
  end
end
