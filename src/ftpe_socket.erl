-module(ftpe_socket).
-author("Schmitt").

-behaviour(gen_fsm).

%% Work with client

% start link
-export([start_link/1]).
% gen_fsm api.
-export([]).

-spec start_link(port()) -> {ok, pid()} | {error, term()}.
start_link(Socket) ->
  gen_fsm:start_link(?MODULE, Socket, []).