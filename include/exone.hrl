
-record(exone, {
    id   = kvs:seq([], []) :: integer(),
    pid  = [] :: [] | pid(),
    name = [] :: [] | string(),
    code = [] :: [] | term()
    }).
