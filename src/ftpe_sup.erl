
-module(ftpe_sup).
-author("Schmitt").

-behaviour(supervisor).

%% Supervisor control user threads.

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% API
-spec start_link() -> {ok, pid()} | {error, term()}.
start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% Supervisor callbacks.
init([])->
  RestartStrategy = one_for_one,
  MaxRestarts = 10,
  MaxSecondsBetweenRestarts = 1,

  SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

  {ok, {SupFlags, []}}.