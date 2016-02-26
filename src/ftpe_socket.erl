-module(ftpe_socket).
-author("Schmitt").

-behaviour(gen_fsm).

%% Work with client

% API
-export([start_link/1]).
% gen_fsm callbacks.
-export([init/1, terminate/3]).
% States
-export([dummy/2, ftp_greeting/2, username/2, password/2]).


-define(EOL,"\n").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% API.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-spec start_link(port()) -> {ok, pid()} | {error, term()}.
start_link(Socket) ->
  gen_fsm:start_link(?MODULE, Socket, [Socket]).

%% gen_fsm callback.
init(ListenSocket)->
  io:format("  Socket thread started!~n"),
  {ok, ftp_greeting, ListenSocket, 0}.

terminate(_Reason, _StateName, ListenSocket) ->
  gen_tcp:close(ListenSocket).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% States.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ftp_greeting(_, ListenSocket) ->
  Greeting = "220 Server ready" ++ ?EOL,
  io:format("~s~n", [Greeting]),
  gen_tcp:send(ListenSocket, Greeting),

  {next_state, username, ListenSocket, 0}.

username(_, ListenSocket) ->
  {ok, Binary} = gen_tcp:recv(ListenSocket, 0),
  {Cmd, _Par} = ftpe_lib:dispatch(Binary),
  io:format("~s~n", [binary:bin_to_list(Binary)]),
  case Cmd=="USER" of
    true ->
      %io:format("~s ~n",[Cmd]),
      case ftpe_properties:isAnon() of
        true ->
          Response = "230 Anonymous is ok." ++ ?EOL,
          io:format("~s ~s~n",[Cmd, Response]),
          gen_tcp:send(ListenSocket, Response),
          {next_state, username, ListenSocket,0};
        false->
          Response = "331 want password" ++ ?EOL,
          io:format("~s ~s~n",[Cmd, Response]),
          gen_tcp:send(ListenSocket, Response),
          {next_state, username, ListenSocket,0}
      end;
    false ->
      Response = "500 command unrecognized." ++ ?EOL,
      io:format("~s ~s~n",[Cmd, Response]),
      gen_tcp:send(ListenSocket, Response),
      {next_state, username, ListenSocket,0}
  end.

password(_, ListenSocket)->
  {ok, Binary} = gen_tcp:recv(ListenSocket, 0).

authorized(_, ListenSocket) ->
  {ok, Binary} = gen_tcp:recv(ListenSocket, 0).

dummy(_, ListenSocket) ->
    case gen_tcp:recv(ListenSocket, 0) of
      {ok, Binary} ->
        ftpe_lib:dispatch(Binary),
        io:format("~s~n", [binary:bin_to_list(Binary)]),
        {next_state, dummy, ListenSocket,0};
      {error, closed} ->
        {stop, "Socket closed", ListenSocket}
    end.