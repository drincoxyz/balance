# balance

This is a serverside library for Garry's Mod that can be used for [team](https://wiki.facepunch.com/gmod/team) balancing.

## Examples

```lua
balance.Add(TEAM_RED)
```

This adds the red team (whichever index that may be) to the balance system. **By default, no teams are included in the balance system** - each team must be manually added. It is recommended to do this in the hook in the following example.

```lua
function GM:SetupTeamBalance()
	balance.Add(TEAM_RED)
	balance.Add(TEAM_BLUE)
end
```

This will add both red and blue team to the balance system during the creation of teams in the `GM:CreateTeams` hook. `GM:SetupTeamBalance` is a custom hook that is called during the former hook.

The difference between these hooks is that the former is called in a shared setting, while the latter is only called by the server, since the balance library is only available to the server.

```lua
balance.Remove(TEAM_RED)
```

This removes the red team from the balance system, if it was added previously.

```lua
balance.Get()
```

This returns an ordered, cached list describing the current balance of every relevant team.

The first teams in the list are considered the most over-balanced teams, while the last teams are the most under-balanced teams, in terms of player count.

Each entry in this list contains a number that represents how many less players that team has compared to the most over-balanced team(s). As you go down the list, this number will naturally decrease as it reaches the bottom (over-balanced).

While this library doesn't auto-balance the teams for you, this function is the real meat of the library, as it provides the information needed to do this on a per-gamemode basis.

## License

This is licensed under the [DBAD License](license.md).
