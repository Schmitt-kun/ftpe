
-module(ftpe_lib).
-author("Schmitt").

%% API
-export([dispatch/1]).

-include("ftpe_header.hrl").

-spec dispatch(binary()) -> #command{}.
dispatch(Command) ->
  CommandStr = binary_to_list(Command),
  [Head | Tail] = re:split(lists:droplast(CommandStr), " "),
  io:format("~s : ~s~n",[Head, Tail]),
  {binary_to_list(Head), tail_list(Tail)}.

%% TODO try find lists function
tail_list([]) ->
  [];
tail_list([Head | Tail]) ->
  [binary_to_list(Head),tail_list(Tail)].






