defmodule ShopWeb.PageLive do
  use ShopWeb, :live_view

  alias Shop.Catalog
  alias Shop.Shopper

  @impl true
  def mount(_params, %{"cart" => cart}, socket) do
    products = Catalog.list_products()
    ShopWeb.Endpoint.subscribe("cart:#{cart.id}")
    {:ok, assign(socket, products: products, cart: cart)}
  end

  @impl true
  def handle_event("add-to-cart", %{"id" => id} = _value, socket) do
    product = Catalog.get_product!(id)
    {:ok, cart} = Shopper.add_to_cart(socket.assigns.cart, product)
    broadcast(cart)
    {:noreply, assign(socket, cart: cart)}
  end

  @impl true
  def handle_event("remove-from-cart", %{"id" => id} = _value, socket) do
    cart_item = Shop.Repo.get(Shopper.CartItem, id)
    {:ok, cart} = Shopper.remove_from_cart(cart_item)
    broadcast(cart)
    {:noreply, assign(socket, cart: cart)}
  end

  @impl true
  def handle_event(
        "update_quantity",
        %{"cart_item" => %{"quantity" => quantity, "id" => id}} = _value,
        socket
      ) do
    cart_item = Shop.Repo.get(Shopper.CartItem, id)
    {:ok, cart} = Shopper.update_item_quantity(cart_item, quantity)
    broadcast(cart)
    {:noreply, assign(socket, cart: cart)}
  end

  @impl true
  def handle_info(%{event: "updated_cart", payload: cart}, socket) do
    {:noreply, assign(socket, cart: cart)}
  end

  defp format_price(price) do
    ShopWeb.LayoutView.format_price(price)
  end

  defp cart_total(cart) do
    cart |> Shopper.cart_total() |> format_price()
  end

  defp broadcast(cart) do
    ShopWeb.Endpoint.broadcast!("cart:#{cart.id}", "updated_cart", cart)
  end
end
