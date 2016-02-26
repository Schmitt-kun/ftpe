%%%-------------------------------------------------------------------
%%% @author Schmitt
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Февр. 2016 20:39
%%%-------------------------------------------------------------------
-module(ftpe_top_sup).
-author("Schmitt").

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

init([]) ->
  RestartStrategy = one_for_one,
  MaxRestarts = 1000,
  MaxSecondsBetweenRestarts = 3600,

  SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

  Restart = permanent,
  Shutdown = 2000,
  Type = worker,

  Ftpe_server = {ftpe_server, {ftpe_server, start_link, []},
    Restart, Shutdown, Type, [ftpe_server]},

  Ftpe_sup = {ftpe_sup, {ftpe_sup, start_link, []},
    Restart, Shutdown, supervisor, [ftpe_sup]},

  Ftpe_prop = {ftpe_properties, {ftpe_properties, start_link, []},
    Restart, Shutdown, Type, [ftpe_properties]},

  {ok, {SupFlags, [Ftpe_server, Ftpe_sup, Ftpe_prop]}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
