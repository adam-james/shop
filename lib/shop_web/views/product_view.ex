defmodule ShopWeb.ProductView do
  use ShopWeb, :view

  def has_error?(form, field) do
    form.errors
    |> Keyword.get_values(field)
    |> (fn values -> !Enum.empty?(values) end).()
  end
end
