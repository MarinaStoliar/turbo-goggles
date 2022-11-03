-module(index).
-include_lib("n2o/include/n2o.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("bpe/include/bpe.hrl").
-include("exone.hrl").
-export([event/1, auth/1, action/2]).

event(init) ->
    n2o:reg(n2o:sid()),
    P = exone:p1(),
    P1 = P#process{module=index},

    R1 = #reader{} = kvs:reader("/feed/persons"),
    R2 = #reader{args=Ones} = kvs:take(R1#reader{args=5}),

    [ io:format("~p~n", [O]) || O <- Ones],

    nitro:update(tab, #table{id=tab, body=#tbody{body= 
        [#tr{cells=[
            #td{body=[nitro:to_binary(O#exone.name)]}, 
            #td{body=[nitro:to_binary(O#exone.code)] }]} || O <- Ones ]} }),

    case bpe:start(P1, []) of
        {ok, Pid} ->
            io:format("started ~p~n", [Pid]),
            bpe:next(Pid),
            Rec = #exone{pid=Pid},
            nitro:update(app, #panel{id=app, body=[
                %#h2{id= <<"head">>,body= <<"Hello">>},
                %#input{id="in1"},
                %#button{body= <<"send">>, postback=yo, source=["in1"]}
                form:new(exone:doc(Rec), Rec),
                #panel{id=canvas}
            ]});
        {error, E} -> {error,E}
    end;
    %nitro:wire("Bpmn.run('/reg1.bpmn');");

event({send, exone, Id, Pid}) ->
    
    E = #exone{id=Id},
    Sources = form:sources(E, []),
    E1 = lists:foldl(fun(S, Ei) ->
                case nitro:q(S) of
                    [] -> Ei;
                    <<>> -> Ei;
                    V ->
                       [_,Fid|_] = string:split(S, "_", all),
                       form:evoke(Ei, nitro:to_atom(Fid), V)
                end
                end, E, Sources),
    Eid = kvs:append(E1, "/feed/persons"),
    io:format("pid ~p~n", [Pid]),
    bpe:amend(Pid, E1),
    bpe:next(Pid),
    io:format("new person: ~p~n", [Eid]);

event({cancel,exone,Id,Pid}) ->
    E = #exone{id=Id},
    FormId = form:atom([form, Id, form:type(E), form:kind([])]),
    E1 = #exone{},
    nitro:update(FormId, form:new(exone:doc(E1), E1));

event(yo) ->
    In = nitro:q("in1"),
    io:format("q: ~p~n", [In]),
    nitro:update(<<"head">>, 
        #h2{id= <<"head">>, body= string:join(["Hello", nitro:to_list(In)], ", ")});

event(Ev) -> io:format("ev: ~p~n", [Ev]).

auth(_) -> true.
action({request, Src, Target}, #process{}) ->
    io:format("action: ~p ~p~n", [Src, Target]).

