defmodule ShopWeb.PageLive do
  use ShopWeb, :live_view

  alias Shop.Catalog
  alias Shop.Shopper

  @impl true
  def mount(_params, %{"cart" => cart}, socket) do
    products = Catalog.list_products()
    {:ok, assign(socket, products: products, cart: cart)}
  end

  def handle_event("add-to-cart", %{"id" => id} = value, socket) do
    product = Catalog.get_product!(id)
    {:ok, cart} = Shopper.add_to_cart(socket.assigns.cart, product)
    {:noreply, assign(socket, cart: cart)}
  end

  def handle_event("remove-from-cart", %{"id" => id} = value, socket) do
    cart_item = Shop.Repo.get(Shopper.CartItem, id)
    {:ok, cart} = Shopper.remove_from_cart(cart_item)
    {:noreply, assign(socket, cart: cart)}
  end

  defp format_price(price) do
    dollars = div(price, 100)
    cents = rem(price, 100)

    "$" <> to_string(dollars) <> "." <> to_string(cents)
  end
end
