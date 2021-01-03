defmodule ShopWeb.HeaderComponent do
  use Phoenix.LiveComponent
  alias ShopWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~L"""
    <header>
      <nav class="navbar" role="navigation" aria-label="main navigation">
        <div class="navbar-brand">
          <%= live_redirect "LOGO", to: Routes.live_path(@socket, ShopWeb.PageLive), class: "navbar-item" %>
        </div>

        <div id="navbarBasicExample" class="navbar-menu">
          <div class="navbar-start">
            <a href="#" class="navbar-item">Placeholder</a>
          </div>

          <div class="navbar-end">
            <%= live_redirect to: Routes.cart_path(@socket, :index), class: "navbar-item" do %>
              <span class="mr-1"><%= Shop.Shopper.cart_item_count(@cart) %></span>
              <span class="icon">
                <i class="fas fa-shopping-cart"></i>
              </span>
            <% end %>
          </div>
        </div>
      </nav>
    </header>
    """
  end
end
