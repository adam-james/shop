# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Shop.Repo.insert!(%Shop.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Shop.Catalog

unless Catalog.list_products() |> length() > 0 do
  Enum.each(0..500, fn _ ->
    title = Faker.Commerce.En.product_name()
    price = :rand.uniform(10_000)
    attrs = %{title: title, price: price}
    Catalog.create_product(attrs)
  end)
end
