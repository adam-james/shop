defmodule ShopWeb.PaginationComponent do
  use Phoenix.LiveComponent
  alias ShopWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~L"""
    <nav class="pagination is-centered" role="navigation" aria-label="pagination">
      <%= live_patch "Previous Page", to: Routes.live_path(@socket, @mod, %{"page" => @page - 1}),
                                      class: "pagination-previous",
                                      disabled: @page == 1 %>
      <%= live_patch "Next Page", to: Routes.live_path(@socket, @mod, %{"page" => @page + 1}),
                                  class: "pagination-next",
                                  disabled: @page == @total_pages %>

      <ul class="pagination-list">
        <%= cond do %>
        <% @page == 1 -> %>
          <li>
            <%= live_patch "1", to: Routes.live_path(@socket, @mod, %{"page" => 1}), class: "pagination-link is-current", aria_label: "Goto page 1", disabled: true %>
          </li>
          <li>
            <%= live_patch @page + 1, to: Routes.live_path(@socket, @mod, %{"page" => @page + 1}), class: "pagination-link",  aria_label: "Goto page " <> to_string(@total_pages) %>
          </li>
          <li>
            <%= live_patch @page + 2, to: Routes.live_path(@socket, @mod, %{"page" => @page + 2}), class: "pagination-link",  aria_label: "Goto page " <> to_string(@total_pages) %>
          </li>
          <li><span class="pagination-ellipsis">&hellip;</span></li>
          <li>
            <%= live_patch @total_pages, to: Routes.live_path(@socket, @mod, %{"page" => @total_pages}), class: "pagination-link",  aria_label: "Goto page " <> to_string(@total_pages) %>
          </li>
        <% @page == 2 -> %>
          <li>
            <%= live_patch "1", to: Routes.live_path(@socket, @mod, %{"page" => 1}), class: "pagination-link", aria_label: "Goto page 1" %>
          </li>
          <li>
            <%= live_patch @page, to: Routes.live_path(@socket, @mod, %{"page" => @page }), class: "pagination-link is-current", disabled: true, aria_label: "Goto page " <> to_string(@total_pages) %>
          </li>
          <li>
            <%= live_patch @page + 1, to: Routes.live_path(@socket, @mod, %{"page" => @page + 1}), class: "pagination-link",  aria_label: "Goto page " <> to_string(@total_pages) %>
          </li>
          <li><span class="pagination-ellipsis">&hellip;</span></li>
          <li>
            <%= live_patch @total_pages, to: Routes.live_path(@socket, @mod, %{"page" => @total_pages}), class: "pagination-link",  aria_label: "Goto page " <> to_string(@total_pages) %>
          </li>
        <% @page == @total_pages - 1 -> %>
          <li>
            <%= live_patch "1", to: Routes.live_path(@socket, @mod, %{"page" => 1}), class: "pagination-link", aria_label: "Goto page 1" %>
          </li>
          <li><span class="pagination-ellipsis">&hellip;</span></li>
          <li>
            <%= live_patch @page - 1, to: Routes.live_path(@socket, @mod, %{"page" => @page - 1}), class: "pagination-link",  aria_label: "Goto page " <> to_string(@total_pages) %>
          </li>
          <li>
            <%= live_patch @page, to: Routes.live_path(@socket, @mod, %{"page" => @page}), class: "pagination-link is-current", disabled: true,  aria_label: "Goto page " <> to_string(@total_pages) %>
          </li>
          <li>
            <%= live_patch @total_pages, to: Routes.live_path(@socket, @mod, %{"page" => @total_pages}), class: "pagination-link",  aria_label: "Goto page " <> to_string(@total_pages) %>
          </li>
        <% @page == @total_pages -> %>
          <li>
            <%= live_patch "1", to: Routes.live_path(@socket, @mod, %{"page" => 1}), class: "pagination-link", aria_label: "Goto page 1" %>
          </li>
          <li><span class="pagination-ellipsis">&hellip;</span></li>
          <li>
            <%= live_patch @page - 2, to: Routes.live_path(@socket, @mod, %{"page" => @page - 2}), class: "pagination-link",  aria_label: "Goto page " <> to_string(@total_pages) %>
          </li>
          <li>
            <%= live_patch @page - 1, to: Routes.live_path(@socket, @mod, %{"page" => @page - 1}), class: "pagination-link",  aria_label: "Goto page " <> to_string(@total_pages) %>
          </li>
          <li>
            <%= live_patch @total_pages, to: Routes.live_path(@socket, @mod, %{"page" => @total_pages}), class: "pagination-link is-current", disabled: true,  aria_label: "Goto page " <> to_string(@total_pages) %>
          </li>
        <% true -> %>
          <li>
            <%= live_patch "1", to: Routes.live_path(@socket, @mod, %{"page" => 1}), class: "pagination-link", aria_label: "Goto page 1" %>
          </li>
          <li><span class="pagination-ellipsis">&hellip;</span></li>
          <li>
            <%= live_patch @page - 1, to: Routes.live_path(@socket, @mod, %{"page" => @page - 1}), class: "pagination-link",  aria_label: "Goto page " <> to_string(@total_pages) %>
          </li>
          <li>
            <%= live_patch @page, to: Routes.live_path(@socket, @mod, %{"page" => @total_pages}), class: "pagination-link is-current",  aria_label: "Goto page " <> to_string(@total_pages), disabled: true %>
          </li>
          <li>
            <%= live_patch @page + 1, to: Routes.live_path(@socket, @mod, %{"page" => @page + 1}), class: "pagination-link",  aria_label: "Goto page " <> to_string(@total_pages) %>
          </li>
          <li><span class="pagination-ellipsis">&hellip;</span></li>
          <li>
            <%= live_patch @total_pages, to: Routes.live_path(@socket, @mod, %{"page" => @total_pages}), class: "pagination-link",  aria_label: "Goto page " <> to_string(@total_pages) %>
          </li>
        <% end %>
      </ul>
    </nav>
    """
  end
end
