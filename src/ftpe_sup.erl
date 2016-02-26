
-module(ftpe_sup).
-author("Schmitt").

-behaviour(supervisor).

%% Supervisor control user threads.

%% API
-export([start_link/0, start_socket/1]).

%% Supervisor callbacks
-export([init/1]).

%% API
-spec start_link() -> {ok, pid()} | {error, term()}.
start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

-spec start_socket(port()) -> ok.
start_socket(ListenSocket)->
  io:format("  Supervisor, start child thread.~n"),
  Id = erlang:unique_integer(),
  ChildSpec = {Id, {ftpe_socket, start_link, [ListenSocket]},
      permanent, 100, worker, [ftpe_socket]},
  supervisor:start_child(?MODULE, ChildSpec),
  ok.

%% Supervisor callbacks.
init([])->
  RestartStrategy = one_for_one,
  MaxRestarts = 3,
  MaxSecondsBetweenRestarts = 1,

  SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

  {ok, {SupFlags, []}}.