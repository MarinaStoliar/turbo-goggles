-module(exone).
-include_lib("kvs/include/metainfo.hrl").
-include_lib("form/include/meta.hrl").
-include_lib("bpe/include/bpe.hrl").
-include("exone.hrl").
-compile(export_all).

metainfo() -> #schema{name=exone, tables=tables()}.
tables() -> [ #table{name=exone, fields=record_info(fields, exone)} ].

doc(#exone{id=Id, pid=Pid}) -> 
    #document{
        name = Id, 
        sections = [#sec{id=s1, name = <<"user">>, desc=[]}],
        fields = [
            #field{id=name, sec=s1, pos=3, type=string, title= <<"Name">>},
            #field{id=code, sec=s1, pos=4, type=number, title= <<"Code">>}
        ],
        buttons = [
            #but{id=ok, class=[btn], title= <<"send">>, 
                postback={send, exone, Id, Pid},
                validation = [],
                sources = [name, code]
            },
            #but{id=cancel, class=[btn], title= <<"cancel">>, 
                postback = {cancel, exone, Id, Pid},
                validation =[]
            }
        ]
    }.

p1() -> 
    case bpe_xml:load(code:priv_dir(exone)++"/static/reg1.bpmn") of {error, E} -> #process{}; P1 -> P1 end.