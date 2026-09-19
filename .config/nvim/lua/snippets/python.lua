local parse = require("luasnip").parser.parse_snippet

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

	-- Geometry Functions (Extracted from PDF) [cite: 2159, 2164]
	parse(
		"geom_inter_circle",
		[[
def find_intersection_with_circle(xl, yl, xr, yr, r):
    while True:
        xm = (xr + xl) / 2
        ym = (yr + yl) / 2
        dis = (xm * xm + ym * ym)**0.5
        if abs(dis - r) < 1e-7:
            return (xm, ym)
        elif dis < r:
            xl, yl = xm, ym
        else:
            xr, yr = xm, ym
]]
	),

	parse(
		"geom_line",
		[[
def find_slope(x1, y1, x2, y2):
    if x1 == x2: return float("inf")
    return (y2 - y1) / (x2 - x1)

def find_intercept(x, y, m):
    if m == float("inf"): return x
    return y - m * x

def find_intersection(m1, b1, m2, b2):
    if m1 == m2: return None
    if m1 == float("inf"):
        x0 = b1
        y0 = m2 * x0 + b2
    elif m2 == float("inf"):
        x0 = b2
        y0 = m1 * x0 + b1
    else:
        x0 = (b2 - b1) / (m1 - m2)
        y0 = m1 * x0 + b1
    return (x0, y0)
]]
	),

	-- Union-Find (Translated from C++) [cite: 2551, 2574, 2598]
	parse(
		"union_find",
		[[
class UnionFind:
    def __init__(self, n):
        self.parent = list(range(n))
        self.rank = [0] * n
        self.n_disjoint = n

    def find(self, i):
        root = i
        while self.parent[root] != root:
            root = self.parent[root]
        
        while self.parent[i] != root:
            next_node = self.parent[i]
            self.parent[i] = root
            i = next_node

        return root

    def unite(self, i, j):
        root_i = self.find(i)
        root_j = self.find(j)
        if root_i == root_j:
          return False

        if self.rank[root_i] < self.rank[root_j]:
            self.parent[root_i] = root_j
        elif self.rank[root_i] > self.rank[root_j]:
            self.parent[root_j] = root_i
        else:
            self.parent[root_j] = root_i
            self.rank[root_i] += 1
        self.n_disjoint -= 1
        return True
]]
	),

	-- Dijkstra (Translated from C++) [cite: 2371, 2385]
	parse(
		"dijkstra",
		[[
import heapq

def dijkstra(adj, source, n):
    dist = [float('inf')] * n
    dist[source] = 0
    pq = [(0, source)]
    
    while pq:
        d, u = heapq.heappop(pq)
        if d > dist[u]: continue
        for v, weight in adj[u]:
            if dist[u] + weight < dist[v]:
                dist[v] = dist[u] + weight
                heapq.heappush(pq, (dist[v], v))
    return dist
]]
	),

	-- KMP (Translated from C++) [cite: 2643, 2657, 2682]
	parse(
		"kmp_match",
		[[
def compute_prefix(P):
    m = len(P)
    pf = [-1] * m
    k = -1
    for q in range(1, m):
        while k >= 0 and P[k+1] != P[q]:
            k = pf[k]
        if P[k+1] == P[q]: k += 1
        pf[q] = k
    return pf

def kmp_match(T, P):
    n, m = len(T), len(P)
    if m == 0: return []
    pf = compute_prefix(P)
    matches = []
    q = -1
    for i in range(n):
        while q >= 0 and P[q+1] != T[i]:
            q = pf[q]
        if P[q+1] == T[i]: q += 1
        if q == m - 1:
            matches.append(i - m + 1)
            q = pf[q]
    return matches
]]
	),

	-- Cumulative Sum of Divisors (CSOD) [cite: 2179, 2182]
	parse(
		"csod",
		[[
def csod(n):
    ans = 0
    i = 2
    while i * i <= n:
        j = n // i
        ans += (i + j) * (j - i + 1) // 2
        ans += i * (j - i)
        i += 1
    return ans
]]
	),
}
