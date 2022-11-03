defmodule ExOne.Routes do
    use N2O, with: [:n2o]

    def finish(state, context), do: {:ok, state, context}

    def init(state, context) do
        %{path: path} = cx(context, :req)
        {:ok, state, cx(context, path: path, module: prefix(path))}
    end
    
    defp prefix(<<"/ws/", r::binary>>), do: route(r)
    defp prefix(<<"/", r::binary>>), do: route(r)
    defp prefix(p), do: route(p)

    def route(<<>>), do: :index
    def route(<<"index", _::binary>>), do: :index
    def route(_), do: :index

end
