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
  [
    %{title: "Apple", price: 199},
    %{title: "Orange", price: 299},
    %{title: "Pear", price: 259},
    %{title: "Banana", price: 159},
    %{title: "Peach", price: 399}
  ]
  |> Enum.each(fn attrs ->
    Catalog.create_product(attrs)
  end)
end
