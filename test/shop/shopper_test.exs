defmodule Shop.ShopperTest do
  use Shop.DataCase

  alias Shop.Shopper
  alias Shop.Catalog

  describe "carts" do
    alias Shop.Shopper.Cart

    @valid_attrs %{}

    def cart_fixture(attrs \\ %{}) do
      {:ok, cart} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Shopper.create_cart()

      cart
    end

    def product_fixture do
      {:ok, product} = Catalog.create_product(%{title: "Apple", price: 199})
      product
    end

    test "add to and remove from cart" do
      cart = cart_fixture()
      product = product_fixture()

      {:ok, cart} = Shopper.add_to_cart(cart, product)
      {:ok, cart} = Shopper.add_to_cart(cart, product)
      [cart_item1 | rest] = cart.items
      [cart_item2 | []] = rest

      assert cart_item1.product == product
      assert cart_item2.product == product

      {:ok, cart} = Shopper.remove_from_cart(cart_item2)
      assert cart.items == [cart_item1]

      {:ok, cart} = Shopper.remove_from_cart(cart_item1)
      assert cart.items == []
    end

    test "get_cart!/1 returns the cart with given id" do
      cart = cart_fixture()
      found = Shopper.get_cart!(cart.id)
      assert cart.id == found.id
    end

    test "create_cart/1 with valid data creates a cart" do
      assert {:ok, %Cart{}} = Shopper.create_cart(@valid_attrs)
    end

    test "delete_cart/1 deletes the cart" do
      cart = cart_fixture()
      assert {:ok, %Cart{}} = Shopper.delete_cart(cart)
      assert_raise Ecto.NoResultsError, fn -> Shopper.get_cart!(cart.id) end
    end

    test "cart_total/1" do
      cart = cart_fixture()
      assert Shopper.cart_total(cart) == 0
      
      product = product_fixture()
      {:ok, cart} = Shopper.add_to_cart(cart, product)
      assert Shopper.cart_total(cart) == 199

      {:ok, cart} = Shopper.add_to_cart(cart, product)
      assert Shopper.cart_total(cart) == 398
    end
  end
end
