%%%-------------------------------------------------------------------
%%% @author Schmitt
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Февр. 2016 16:30
%%%-------------------------------------------------------------------
-module(ftpe_app).
-author("Schmitt").

-behaviour(application).

%% Application callbacks
-export([start/2,
  stop/1]).

%%%===================================================================
%%% Application callbacks
%%%===================================================================

start(_StartType, _StartArgs) ->
  ftpe_top_sup:start_link().

stop(_State) ->
  ok.
