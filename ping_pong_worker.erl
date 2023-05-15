-module(ping_pong_worker).
-author("Phuc Nguyen").
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2]).
-export([terminate/2, code_change/3]).

-export([stop/0, check_message/0, clear_state/0]).
-export([start/0, ping/1]).


start() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
    gen_server:cast(?MODULE, stop).

ping({PongGenName, PongNode}) ->
    gen_server:cast(?MODULE, {ping, {PongGenName, PongNode, nothing}}).

check_message() ->
    gen_server:call(?MODULE, check_message).

clear_state() ->
    gen_server:call(?MODULE, clear_state).

init([]) ->
    % process_flag(trap_exit, true),
    {ok, {0, 0}}.

handle_call(check_message, _From, State) ->
    {reply, State, State};

handle_call(clear_state, _From, _State) ->
    NewState = {0, 0},
    {reply, NewState, NewState}.

handle_cast({ping, {PongGenName, PongNode, _}}, {NumberOfPings, NumberOfPongs}) ->
    Characters = ['a', 'b', 'c', 'd', 'e'],
    Numbers = [1, 2, 3, 4, 5],
    GenName = proplists:get_value(registered_name, erlang:process_info(self())),
    io:format("ping ~w~w~n", [Characters, Numbers]),
    if
    NumberOfPings < 1000 ->
        gen_server:cast({PongGenName, PongNode}, {pong,  {GenName, node(), Characters, Numbers}}),
        gen_server:cast({PongGenName, PongNode}, {pong,  {GenName, node(), Characters, Numbers}});
    NumberOfPings < 2000 ->
        gen_server:cast({PongGenName, PongNode}, {pong,  {GenName, node(), Characters, Numbers}});
    true ->
        ok
    end,
    {noreply, {NumberOfPings + 1, NumberOfPongs}};

handle_cast({pong, {PingGenName, PingNode, Characters, Numbers}}, {NumberOfPings, NumberOfPongs}) ->
    Result = maps:from_list(lists:zip(Characters, Numbers)),
    GenName = proplists:get_value(registered_name, erlang:process_info(self())),
    io:format("pong ~w~n", [Result]),
    if
    NumberOfPongs < 1000 ->
        gen_server:cast({PingGenName, PingNode}, {ping,  {GenName, node(), Result}}),
        gen_server:cast({PingGenName, PingNode}, {ping,  {GenName, node(), Result}});
    NumberOfPongs < 2000 ->
        gen_server:cast({PingGenName, PingNode}, {ping,  {GenName, node(), Result}});
    true ->
        ok
    end,
    {noreply, {NumberOfPings, NumberOfPongs + 1}};

handle_cast(stop, State) ->
    {stop, normal, State};

handle_cast(_Message, State) -> {noreply, State}.

terminate(normal, _State) -> 
    ok.

handle_info(_Info, State) -> {noreply, State}.
code_change(_OldVersion, Dictionary, _Extra) -> {ok, Dictionary}.

