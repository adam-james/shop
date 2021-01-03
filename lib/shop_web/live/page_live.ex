defmodule ShopWeb.PageLive do
  use ShopWeb, :live_view

  alias Shop.Catalog
  alias Shop.Shopper

  # Add search

  @impl true
  def mount(params, %{"cart" => cart}, socket) do
    page = Catalog.list_products(params)
    if connected?(socket), do: ShopWeb.Endpoint.subscribe("cart:#{cart.id}")

    {:ok, assign(socket, page: page, cart: cart)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    page = Catalog.list_products(params)
    {:noreply, assign(socket, page: page)}
  end

  @impl true
  def handle_event("add-to-cart", %{"id" => id} = _value, socket) do
    product = Catalog.get_product!(id)
    {:ok, cart} = Shopper.add_to_cart(socket.assigns.cart, product)
    broadcast(cart)
    socket = socket |> put_flash(:info, "Product added to cart.")
    {:noreply, assign(socket, cart: cart)}
  end

  @impl true
  def handle_info(%{event: "updated_cart", payload: cart}, socket) do
    {:noreply, assign(socket, cart: cart)}
  end

  defp format_price(price) do
    ShopWeb.LayoutView.format_price(price)
  end

  defp broadcast(cart) do
    ShopWeb.Endpoint.broadcast!("cart:#{cart.id}", "updated_cart", cart)
  end
end
