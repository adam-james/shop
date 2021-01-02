defmodule Shop.Shopper do
  @moduledoc """
  The Shopper context.
  """

  import Ecto.Query, warn: false
  alias Shop.Repo

  alias Shop.Shopper.{Cart, CartItem}
  alias Shop.Catalog.Product

  @doc """
  Adds a product to cart.
  """
  def add_to_cart(%Cart{} = cart, %Product{} = product) do
    query =
      from ci in CartItem,
        where: ci.cart_id == ^cart.id and ci.product_id == ^product.id,
        limit: 1

    case Repo.all(query) do
      [] ->
        {:ok, _} = %CartItem{cart_id: cart.id, product_id: product.id} |> Repo.insert()

      [cart_item | []] ->
        {:ok, _} =
          cart_item
          |> CartItem.changeset(%{quantity: cart_item.quantity + 1})
          |> Repo.update()
    end

    cart = get_cart!(cart.id)

    {:ok, cart}
  end

  @doc """
  Updates a cart item's quantity.
  """
  def update_item_quantity(%CartItem{} = cart_item, quantity) when quantity > 0 do
    {:ok, _} =
      cart_item
      |> CartItem.changeset(%{quantity: quantity})
      |> Repo.update()

    cart = get_cart!(cart_item.cart_id)

    {:ok, cart}
  end

  @doc """
  Removes a cart item from cart.
  """
  def remove_from_cart(%CartItem{} = cart_item) do
    {:ok, _} = Repo.delete(cart_item)
    cart = get_cart!(cart_item.cart_id)

    {:ok, cart}
  end

  @doc """
  Gets a single cart.

  Raises `Ecto.NoResultsError` if the Cart does not exist.

  ## Examples

      iex> get_cart!(123)
      %Cart{}

      iex> get_cart!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cart!(id) do
    query =
      from c in Cart,
        where: c.id == ^id,
        preload: [
          items:
            ^from(ci in CartItem,
              where: ci.cart_id == ^id,
              preload: [:product],
              order_by: [desc: ci.inserted_at]
            )
        ]

    Repo.get!(query, id)
  end

  @doc """
  Creates a cart.

  ## Examples

      iex> create_cart(%{field: value})
      {:ok, %Cart{}}

      iex> create_cart(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cart(attrs \\ %{}) do
    %Cart{}
    |> Cart.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a cart.

  ## Examples

      iex> delete_cart(cart)
      {:ok, %Cart{}}

      iex> delete_cart(cart)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cart(%Cart{} = cart) do
    Repo.delete(cart)
  end

  @doc """
  Calculates cart total.
  """
  def cart_total(%Cart{} = cart) do
    cart = Repo.preload(cart, items: :product)

    Enum.reduce(cart.items, 0, fn item, acc ->
      acc + item.product.price * item.quantity
    end)
  end

  @doc """
  Get total quantity of items in cart.
  """
  def cart_item_count(%Cart{} = cart) do
    cart = Repo.preload(cart, :items)

    Enum.reduce(cart.items, 0, fn item, acc ->
      acc + item.quantity 
    end)
  end
end
