use Mix.Config

config :kvs,
    dba: :kvs_rocks,
    dba_st: :kvs_st,
    schema: [:kvs, :kvs_stream, :bpe_metainfo, :exone]

config :n2o,
    app: :exone,
    port: 8080,
    mq: :n2o_syn,
    pickler: :n2o_secret,
    session: :n2o_session,
    tables: [:cookies, :tcp, :async, :ws, :caching],
    protocols: [:nitro_n2o, :n2o_heart],
    routes: ExOne.Routes

config :form,
    module: :form_bck
