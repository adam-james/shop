defmodule Shop.Shopper.CartItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cart_items" do
    field :quantity, :integer
    belongs_to :cart, Shop.Shopper.Cart
    belongs_to :product, Shop.Catalog.Product

    timestamps()
  end

  @doc false
  def changeset(cart_item, attrs) do
    cart_item
    |> cast(attrs, [:cart_id, :product_id, :quantity])
    |> validate_required([:cart_id, :product_id])
    |> validate_number(:quantity, greater_than: 0)
  end
end
