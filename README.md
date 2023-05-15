# Phuc's 5Gen Exercise

In this exercise, I use supervisor and gen server behaviors to implement the required problems
Because of lack of time, I only implemented required parts of the execise, I will enhance or add optional parts later

# Steps to run this exercise

> To create node A:

```bash
erl -name nodeA
```

> To create node B:

```bash
erl -sname nodeA
```

> Start supervisor process and its child on node B:

```erlang
c(ping_pong_supervisor).
c(ping_pong_worker).
ping_pong_supervisor:start_link().
```

> Start supervisor process and its child on node A:

```erlang
c(ping_pong_supervisor).
c(ping_pong_worker).
ping_pong_supervisor:start_link().
```

> Trigger ping pong process
If the host name is PhucNguyen

```erlang
ping_pong_worker:ping({ping_pong_worker, 'nodeB@PhucNguyenLexer'}).
```

> See the output on node A:

...
ping [a,b,c,d,e][1,2,3,4,5]
ping [a,b,c,d,e][1,2,3,4,5]
ping [a,b,c,d,e][1,2,3,4,5]
ping [a,b,c,d,e][1,2,3,4,5]
...

> See the number of ping requests on node A:

```erlang
ping_pong_worker:check_message().
{3001,0}
```

> See the output on node B:

...
pong #{a => 1,b => 2,c => 3,d => 4,e => 5}
pong #{a => 1,b => 2,c => 3,d => 4,e => 5}
pong #{a => 1,b => 2,c => 3,d => 4,e => 5}
pong #{a => 1,b => 2,c => 3,d => 4,e => 5}
...

> See the number of ping requests on node B:

```erlang
ping_pong_worker:check_message().
{0, 3000}
```

There is one more ping because of one ping requet to trigger the ping pong chain.

> Restart state in two nodes, run the below command on both of the nodes:

```erlang
ping_pong_worker:clear_state().
{0, 0}
```

> Kill one genserver

```erlang
ping_pong_worker:stop()
```
