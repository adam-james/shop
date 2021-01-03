defmodule ShopWeb.Router do
  use ShopWeb, :router
  import Plug.BasicAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ShopWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug :basic_auth, Application.compile_env(:shop, :basic_auth)
  end

  scope "/", ShopWeb do
    pipe_through [:browser, :ensure_cart]

    live "/", PageLive, session: {ShopWeb.Router, :get_cart, []}
    live "/cart", CartLive, :index, session: {ShopWeb.Router, :get_cart, []}
  end

  scope "/admin", ShopWeb do
    pipe_through [:browser, :admin]

    resources "/products", ProductController
  end

  # Other scopes may use custom stacks.
  # scope "/api", ShopWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ShopWeb.Telemetry
    end
  end

  defp ensure_cart(conn, _) do
    case get_session(conn, :cart_id) do
      nil ->
        {:ok, cart} = Shop.Shopper.create_cart()
        cart = Shop.Repo.preload(cart, items: :product)

        conn
        |> put_session(:cart_id, cart.id)
        |> assign(:cart, cart)

      cart_id ->
        cart = Shop.Shopper.get_cart!(cart_id)
        assign(conn, :cart, cart)
    end
  end

  def get_cart(conn) do
    %{"cart" => conn.assigns.cart}
  end
end
