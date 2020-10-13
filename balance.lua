-- https://github.com/drincoxyz/balance

-- serverside module
if !SERVER then return end
-- reload disabled
-- comment for testing
 if istable(balance) then return end

module("balance", package.seeall)

-- globals
local pairs = pairs
-- math library
local math     = math
local math_max = math.max
-- team library
local team            = team
local team_NumPlayers = team.NumPlayers
-- table library
local table         = table
local table_Copy    = table.Copy
local table_sort    = table.sort
local table_insert  = table.insert
local table_Reverse = table.Reverse

-- team balance
-- switch comment for testing
-- bal = bal || {}
local bal = {}

-- team balance cache flag
-- switch comment for testing
-- cache = cache || false
local cache = false

-- joinable teams
-- switch comment for testing
-- joinable  = joinable  || {}
-- joinable_ = joinable_ || {}
-- joinnum   = joinnum   || 0
local joinable  = {}
local joinable_ = {}
local joinnum   = 0

-- marks team balance for cache
-- doesn't cache until Get is called once after setting
local function Cache()
	cache = true
end

-- adds a team to the balance system
function Add(id)
	-- team already in system
	if joinable_[id] then return end
	-- register team
	joinable_[id] = table.insert(joinable, id)
	-- flag for cache
	Cache()
end

-- removes a team from the balance system
function Remove(id)
	-- team not in system
	if !joinable_[id] then return end
	-- de-register team
	table.remove(joinable, joinable_[id])
	joinable_[id] = nil
	-- flag for cache
	Cache()
end

-- returns the team balance
-- ordered from under-balanced to over-balanced
function Get()
	-- cache required
	if cache then
		local count = {}
		local over
		
		-- empty team balance
		table.Empty(bal)

		-- populate player count
		for i, id in pairs(joinable) do
			table_insert(count, {id = id, num = team_NumPlayers(id)})
		end

		-- sort team counts from highest to lowest
		table_sort(count, function(a, b) return a.num > b.num end)

		for i, data in pairs(count) do
			-- this is the first entry
			if #bal < 1 then
				-- overbalanced = highest player count
				over = data.num
			end
			-- insert entry
			table_insert(bal, {id = data.id, num = over - data.num})
		end

		-- reverse team balance
		bal = table_Reverse(bal)
		-- disable cache
		cache = false
	end
	-- return team balance
	return bal
end

-- attempts to auto-balance the teams
function Auto()
	-- don't auto-balance if not needed
	if !bal[1] || bal[1].num < 1 then return false end

	-- auto-balance successful
	return true
end

-- team join event
hook.Add("PlayerChangedTeam", "balance", function(pl, old, new)
	-- flag for cache
	Cache()
end)
-- disconnect event
hook.Add("PlayerDisconnected", "balance", function(pl)
	-- flag for cache
	Cache()
end)
-- team creation event
hook.Add("CreateTeams", "balance", function()
	-- setup team balance
	gamemode.Call "SetupTeamBalance"
end)
