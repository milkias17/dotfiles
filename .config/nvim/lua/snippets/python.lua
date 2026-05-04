return {
	s(
		"ptf",
		fmt("async def {}(update: Update, ctx: {}):\n\t{}", {
			i(1),
			c(2, {
				t("Context"),
				t("ContextTypes.DEFAULT_TYPE"),
				t("CallbackContext"),
			}),
			i(0),
		})
	),

	s(
		"cfbase",
		fmt(
			[[
import sys

input = sys.stdin.readline

def solve():
    {}

def main():
    {}
    for _ in range(t):
      solve()

if __name__ == "__main__":
    main()
    ]],
			{
				i(1), -- Inside solve()
				c(2, {
					t("t = int(input())"),
					t("t = 1"),
				}),
			}
		)
	),
	s("cfm", fmt("{} = map(int, input().split())", { i(1, "n, k") })),
	s("cfa", fmt("{} = list(map(int, input().split()))", { i(1, "a") })),
	s(
		"cfi",
		fmt(
			"{} = {}",
			{ i(1, "n"), c(2, {
				t("int(input())"),
				t("input().strip()"),
				t("float(input())"),
			}) }
		)
	),
	s("reclimit", {
		t({ "import sys", "sys.setrecursionlimit(" }),
		i(1, "200000"),
		t({ ")" }),
		i(0),
	}),

	s("printl", fmt("print(*( {} ))", { i(1, "arr") })),
	s(
		"binsearch",
		fmt(
			[[
low = {}
high = {}
ans = -1
while low <= high:
    mid = (low + high) // 2
    if {}(mid):
        ans = mid
        {} = mid + 1
    else:
        {} = mid - 1
]],
			{
				i(1, "0"),
				i(2, "10**9"),
				i(3, "check"),
				i(4, "low"),
				i(5, "high"),
			}
		)
	),
	s(
		"dsu",
		fmt(
			[[
parent = list(range({} + 1))
def find(i):
    if parent[i] == i:
        return i
    parent[i] = find(parent[i])
    return parent[i]

def union(i, j):
    root_i = find(i)
    root_j = find(j)
    if root_i != root_j:
        parent[root_i] = root_j
        return True
    return False
]],
			{ i(1, "n") }
		)
	),

	-- Sieve of Eratosthenes
	s(
		"sieve",
		fmt(
			[[
def get_primes(n):
    primes = []
    is_prime = [True] * (n + 1)
    for p in range(2, n + 1):
        if is_prime[p]:
            primes.append(p)
            for i in range(p * p, n + 1, p):
                is_prime[i] = False
    return primes
]],
			{}
		)
	),

	-- Adjacency List for Graphs
	s(
		"adj",
		fmt(
			[[
adj = [[] for _ in range({} + 1)]
for _ in range({}):
    u, v = map(int, input().split())
    adj[u].append(v)
    adj[v].append(u)
]],
			{ i(1, "n"), i(2, "m") }
		)
	),

	-- Directions for Grids (4 and 8 way)
	s("dir4", t("directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]")),
	s("dir8", t("directions = [(0, 1), (0, -1), (1, 0), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]")),

	-- Modular Inverse / Combinations (nCr)
	s(
		"ncr",
		fmt(
			[[
MOD = {}
fact = [1] * ({} + 1)
inv = [1] * ({} + 1)
for i in range(1, {} + 1):
    fact[i] = (fact[i - 1] * i) % MOD

inv[{}] = pow(fact[{}], MOD - 2, MOD)
for i in range({} - 1, -1, -1):
    inv[i] = (inv[i + 1] * (i + 1)) % MOD

def nCr(n, r):
    if r < 0 or r > n:
        return 0
    num = fact[n]
    den = (inv[r] * inv[n - r]) % MOD
    return (num * den) % MOD
]],
			{
				i(1, "10**9 + 7"),
				i(2, "n"),
				i(3, "n"),
				i(4, "n"),
				i(5, "n"),
				i(6, "n"),
				i(7, "n"),
			}
		)
	),
}
