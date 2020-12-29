defmodule ShopWeb.PageLive do
  use ShopWeb, :live_view

  alias Shop.Catalog
  alias Shop.Shopper

  defmodule CartItemSummary do
    defstruct price_per: 0, total: 0, product_title: "", quantity: 0, first_id: -1

    def create(items) when length(items) > 0 do
      first_item = List.first(items)
      first_id = first_item.id
      first_product = first_item.product
      price_per = first_product.price
      quantity = length(items)
      total = price_per * quantity
      product_title = first_product.title

      %__MODULE__{
        first_id: first_id,
        price_per: price_per,
        product_title: product_title,
        quantity: quantity,
        total: total,
      }
    end
  end

  defmodule CartSummary do
    defstruct total: "", item_summaries: []

    def create(cart) do
      %__MODULE__{total: Shopper.cart_total(cart), item_summaries: item_summaries(cart)}
    end

    defp item_summaries(cart) do
      cart.items
        |> Enum.group_by(fn item -> item.product_id end)
        |> Enum.map(fn {_product_id, items} -> CartItemSummary.create(items) end)
    end
  end

  @impl true
  def mount(_params, %{"cart" => cart}, socket) do
    products = Catalog.list_products()
    ShopWeb.Endpoint.subscribe("cart:#{cart.id}")
    {:ok, assign(socket, products: products, cart: cart, cart_summary: CartSummary.create(cart))}
  end

  @impl true
  def handle_event("add-to-cart", %{"id" => id} = _value, socket) do
    product = Catalog.get_product!(id)
    {:ok, cart} = Shopper.add_to_cart(socket.assigns.cart, product)
    broadcast(cart)
    {:noreply, assign(socket, cart: cart, cart_summary: CartSummary.create(cart))}
  end

  @impl true
  def handle_event("remove-from-cart", %{"id" => id} = _value, socket) do
    cart_item = Shop.Repo.get(Shopper.CartItem, id)
    {:ok, cart} = Shopper.remove_from_cart(cart_item)
    broadcast(cart)
    {:noreply, assign(socket, cart: cart, cart_summary: CartSummary.create(cart))}
  end

  @impl true
  def handle_info(%{event: "updated_cart", payload: cart}, socket) do
    {:noreply, assign(socket, cart: cart, cart_summary: CartSummary.create(cart))}
  end

  defp format_price(price) do
    dollars = div(price, 100) |> to_string()
    cents = rem(price, 100) |> to_string()
    cents =
      if String.length(cents) == 1 do
        "0" <> cents
      else
        cents
      end

    "$" <> dollars <> "." <> cents
  end

  defp cart_total(cart) do
    cart |> Shopper.cart_total() |> format_price()
  end

  defp broadcast(cart) do
    ShopWeb.Endpoint.broadcast!("cart:#{cart.id}", "updated_cart", cart)
  end
end
