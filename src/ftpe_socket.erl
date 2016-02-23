-module(ftpe_socket).
-author("Schmitt").

-behaviour(gen_fsm).

%% Work with client

% API
-export([start_link/1]).
% gen_fsm callbacks.
-export([init/1, terminate/3]).
% States
-export([dummy/2]).

% API.
-spec start_link(port()) -> {ok, pid()} | {error, term()}.
start_link(Socket) ->
  gen_fsm:start_link(?MODULE, Socket, [Socket]).

%% gen_fsm callback.
init(ListenSocket)->
  io:format("Socket thread started!~n"),
  {ok, dummy, ListenSocket, 0}.

terminate(_Reason, _StateName, ListenSocket) ->
  gen_tcp:close(ListenSocket).

%% States.
dummy(_, ListenSocket) ->
    case gen_tcp:recv(ListenSocket, 0) of
      {ok, Binary} ->
        io:format("~s~n", [binary:bin_to_list(Binary)]),
        {next_state, dummy, ListenSocket,0};
      {error, closed} ->
        {stop, "Socket closed", ListenSocket}
    end.