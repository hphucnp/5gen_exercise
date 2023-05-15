-module(ping_pong_supervisor).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link(ping_pong_supervisor, []).

init(_Args) ->
    SupFlags = #{strategy => one_for_one, intensity => 1, period => 5},
    ChildSpecs = [#{id => node,
                    start => {ping_pong_worker, start, []},
                    restart => permanent,
                    shutdown => brutal_kill,
                    type => worker,
                    modules => [ping_pong_worker]}],
    {ok, {SupFlags, ChildSpecs}}.