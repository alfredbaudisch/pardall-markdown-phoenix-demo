defmodule PardallMarkdownWeb.Live.Content do
  use PardallMarkdownWeb, :live_view
  alias PardallMarkdown.{Post, Link}

  def mount(%{"slug" => slug}, _session, socket) do
    slug =
      slug
      |> slug_params_to_slug()

    if connected?(socket) do
      Endpoint.subscribe("pardall_markdown_web")
    end

    {:ok, socket |> assign(:slug, slug) |> load_content()}
  end

  def render(%{content: %Post{}} = assigns),
    do: Phoenix.View.render(PardallMarkdownWeb.ContentView, "single_post.html", assigns)

  def render(%{content: %Link{}} = assigns),
    do: Phoenix.View.render(PardallMarkdownWeb.ContentView, "single_taxonomy.html", assigns)

  def handle_info(%{event: "content_reloaded", payload: :all}, socket) do
    {:noreply, socket |> load_content()}
  end

  defp load_content(%{assigns: %{slug: slug}} = socket) do
    content = Repository.get_by_slug!(slug)

    socket
    |> assign(:content, content)
    |> assign_page_title(content)
  end

  defp slug_params_to_slug(slug), do: "/" <> Enum.join(slug, "/")

  defp assign_page_title(socket, %Post{title: title}),
    do: socket |> assign(:page_title, compose_page_title(title))

  defp assign_page_title(socket, %Link{title: title}),
    do: socket |> assign(:page_title, compose_page_title(title))
end
