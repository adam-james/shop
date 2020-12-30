defmodule Shop.Repo.Migrations.AddQuantityToCartItems do
  use Ecto.Migration

  def change do
    alter table(:cart_items) do
      add :quantity, :integer, null: false, default: 1
    end

    create unique_index(:cart_items, [:cart_id, :product_id])
  end
end
