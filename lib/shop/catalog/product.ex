defmodule Shop.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :price, :integer
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:title, :price])
    |> validate_required([:title, :price])
    |> validate_number(:price, greater_than: 0)
  end
end
