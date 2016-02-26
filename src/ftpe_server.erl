-module(ftpe_server).
-author("schmitt-kun").

-behavior(gen_fsm).

%% Awaits connection from clients.
%% Start ftpe_socket for each connected client.

% start link
-export([start_link/0]).
% Gen_fsm API.
-export([init/1, listen_socket/2, terminate/3]).

-type socket() :: port().

-define(PORT, 21).

-spec start_link() -> {ok,pid()} | {error,any()}.
start_link() ->
  gen_fsm:start_link({local, ?MODULE},?MODULE, [], []).

-spec init([]) -> {ok, listen_socket, socket()}.
init([]) ->
  io:format("Server: start.~n"),
  {ok, ListenSocket} = gen_tcp:listen(?PORT, [binary, {active, false}]),
  {ok, listen_socket, ListenSocket,0}.
% FSM only state.

-spec listen_socket(_, socket()) -> {next_state, term(), socket()}.
listen_socket(_, ListenSocket) ->
  io:format("  Server: listen.~n"),
  {ok, Socket} = gen_tcp:accept(ListenSocket),
  io:format("  Server: connection.~n"),
  ftpe_sup:start_socket(Socket),
  {next_state, listen_socket,ListenSocket,0}.

-spec terminate(_,_,socket()) -> ok.
terminate(_Reason, _StateName, ListenSocket) ->
  gen_tcp:close(ListenSocket).