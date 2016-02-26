%% Module
-module(ftpe_properties).
-author("Schmitt").

-bahaviour(gen_server).

%% Base API
-export([start_link/0]).
%% gen server callbacks
-export([init/1, terminate/2, handle_call/3]).
%% Application API
-export([isAnon/0]).

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% Application API

isAnon() ->
  gen_server:call(?MODULE, anonymous).

% gen server callbacks

init([]) ->
  {ok, []}.

terminate(_, _) ->
  ok.

handle_call(anonymous, _From, State) ->
  {reply, true, State}.