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

-spec start_link() -> {ok,pid()} | {error,any()}.
start_link() ->
  gen_fsm:start_link({local, ?MODULE},?MODULE, [], []).

-spec init([]) -> {ok, listen_socket, socket()}.
init([]) ->
  {ok, ListenSocket} = gen_tcp:listen(8081, [binary, {active, false}]),
  {ok, listen_socket, ListenSocket}.
% FSM only state.

-spec listen_socket(_, socket()) -> {next_state, term(), socket()}.
listen_socket(_, ListenSocket) ->
  {ok, Socket} = gen_tcp:accept(ListenSocket),
  {next_stete, listen_socket,ListenSocket}.

-spec terminate(_,_,socket()) -> ok.
terminate(_Reason, _StateName, ListenSocket) ->
  gen_tcp:close(ListenSocket).