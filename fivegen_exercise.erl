-module(fivegen_exercise).
-behaviour(gen_server).


start_link(ConnectedPid) ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [ConnectedPid], []).

ping() ->
    gen_server:call(?MODULE, ping).

pong() ->
    gen_server:call(?MODULE, pong).

init([ConnectedPid]) ->
    process_flag(trap_exit, true),
    {ok, [ConnectedPid]}.

handle_call(ping, _From, State) ->
    Characters = ["a", "b", "c", "d", "e"],
    Numbers = [1, 2, 3, 4, 5],
    ConnectedPid = hd(State),
    ConnectedPid!Characters,
    ConnectedPid!Numbers,
    {reply, _From, State}.

lists.zip()

handle_call(pong, _From, State) ->
    {reply, 

stop() ->
    gen_server:cast(5gen_exercise, stop).

handle_case(stop, State) ->
    {stop, normal, State).
