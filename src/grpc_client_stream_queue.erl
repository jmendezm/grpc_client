-module(grpc_client_stream_queue).
-behaviour(gen_server).

-export([start/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,terminate/2]).
-export([new_stream/5]).

-record(state, {}).

start(ConnPid) ->
  gen_server:start({local, ?MODULE}, ?MODULE, [ConnPid], []).

init([ConnPid]) ->
  link(ConnPid),
  {ok, #state{}}.

handle_call({new_stream,Connection, Service, Rpc, DecoderModule, Options}, _From, State) ->
  {reply, grpc_client_stream:new(Connection, Service, Rpc, DecoderModule, Options), State};
handle_call(_Call, _From, State) ->
  {reply, ok, State}.

handle_cast(_Cast, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

new_stream(Connection, Service, Rpc, DecoderModule, Options) ->
  gen_server:call(?MODULE, {new_stream, Connection, Service, Rpc, DecoderModule, Options}).