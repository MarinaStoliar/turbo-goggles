defmodule ExOne.MixProject do
    use Mix.Project

    def project do
      [
        app: :exone,
        version: "0.1.0",
        elixir: "~> 1.9",
        erlc_path: ["src"],
        start_permanent: Mix.env() == :prod,
        deps: deps()
      ]
    end

    def application do 
      [
        mod: {ExOne.App, []},
        extra_applications: [],
        applications: [
          :syn,
          :ranch,
          :cowboy,
          :n2o,
          :nitro,
          :form,
          :mnesia,
          :rocksdb,
          :kvs,
          :bpe
        ]
      ]
    end

    def deps do 
      [
        {:syn, "~> 2.1.1"},
        {:cowboy, "~> 2.9"},
        {:n2o, "~> 9.4"},
        {:nitro, "~> 7.9", override: true},
        {:form, github: "synrc/forms", ref: "master", override: true},
        {:rocksdb, "~> 1.6.0", override: true},
        {:kvs, "~> 9.9", override: true},
        {:bpe, "~> 7.10"}
      ]
    end
end
