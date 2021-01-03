defmodule ShopWeb.PaginationComponent do
  use Phoenix.LiveComponent
  alias ShopWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~L"""
    <nav class="pagination" role="navigation" aria-label="pagination">
      <%= live_patch to: Routes.live_path(@socket, @mod, %{"page" => @page.page_number - 1}),
                     class: "pagination-previous",
                     disabled: @page.page_number == 1 do %>
        <span class="icon">
          <i class="fas fa-chevron-left"></i>
        </span>
      <% end %>
      <%= live_patch to: Routes.live_path(@socket, @mod, %{"page" => @page.page_number + 1}),
                     class: "pagination-next",
                     disabled: @page.page_number == @page.total_pages do %>
        <span class="icon">
          <i class="fas fa-chevron-right"></i>
        </span>
      <% end %>

      <ul class="pagination-list">
        <%= live_patch "1", to: Routes.live_path(@socket, @mod, %{"page" => 1}),
                            class: (if @page.page_number == 1, do: "pagination-link is-current", else: "pagination-link"), 
                            aria_label: "Goto page 1", 
                            disabled: @page.page_number == 1 %>
        <%= if @page.total_pages > 2 && @page.page_number != 1 && @page.page_number != @page.total_pages do %>
          <%= live_patch @page.page_number, to: Routes.live_path(@socket, @mod, %{"page" => @page.page_number}),
                                            class: "pagination-link is-current", 
                                            aria_label: "Goto page " <> to_string(@page.page_number), 
                                            disabled: true %>
        <% end %>
        <%= if @page.total_pages > 1 do %>
          <%= live_patch @page.total_pages, to: Routes.live_path(@socket, @mod, %{"page" => @page.total_pages}),
                                            class: (if @page.page_number == @page.total_pages, do: "pagination-link is-current", else: "pagination-link"), 
                                            aria_label: "Goto page " <> to_string(@page.total_pages),
                                            disabled: @page.page_number == @page.total_pages %>
        <% end %>
      </ul>
    </nav>
    """
  end
end
