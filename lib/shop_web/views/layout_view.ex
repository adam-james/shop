defmodule ShopWeb.LayoutView do
  use ShopWeb, :view

  def format_price(price) do
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
end
