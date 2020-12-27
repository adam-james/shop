defmodule Shop.Shopper.Cart do
  use Ecto.Schema
  import Ecto.Changeset

  schema "carts" do
    has_many :items, Shop.Shopper.CartItem

    timestamps()
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [])
    |> validate_required([])
  end
end
