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

Each entry in this list contains a number that represents how many more players that team has compared to the most under-balanced team(s). As you go down the list, this number will naturally decrease as it reaches the bottom (under-balanced).

While this library doesn't auto-balance the teams for you, this function is the real meat of the library, as it provides the information needed to do this on a per-gamemode basis.

```lua
print(balance.Test(Entity(1), TEAM_RED))
```

This will print either true, false, or nil based on several criteria. True means the player is permitted by the balance system to join the red team, false if they aren't permitted, or nil if that player is already on the team being tested (nil is used because this is outside the scope of team balancing). It's a quick way to test whether a change in teams would cause an imbalance, and is primarily suited for use in the `GM:PlayerCanJoinTeam` hook.

## License

This is licensed under the [DBAD License](license.md).
