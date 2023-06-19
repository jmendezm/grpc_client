-module(grpc_client_stream_queue).
-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, terminate/2]).
-export([new_stream/5, get_specs/0]).

-record(state, {}).

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
  {ok, #state{}}.

handle_call({new_stream,Connection, Service, Rpc, DecoderModule, Options}, _From, State) ->
  {reply, grpc_client_stream:new(Connection, Service, Rpc, DecoderModule, Options), State};
handle_call(_Call, _From, State) ->
  {reply, ok, State}.

handle_cast(_Cast, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

new_stream(Connection, Service, Rpc, DecoderModule, Options) ->
  gen_server:call(?MODULE, {new_stream, Connection, Service, Rpc, DecoderModule, Options}).

get_specs() ->
  #{id => ?MODULE,
    start => {?MODULE, start_link, []},
    restart => permanent,
    shutdown => infinity,
    type => worker,
    modules => [?MODULE]}.