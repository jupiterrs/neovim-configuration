local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
    -- Competitive Programming Snippet
    s('beg', {
        t {
            'from sys import stdin, stdout',
            'import math',
            'import bisect',
            'from queue import deque',
            'from collections import defaultdict, Counter',
            'from itertools import permutations, combinations',
            '',
            '# Fast input',
            'input = lambda: stdin.readline().strip()',
            "print = lambda x: stdout.write(str(x) + '\\n')",
            '',
        },
    }),

    -- Template for function
    s('defn', {
        t 'def ',
        i(1, 'function_name'),
        t '(',
        i(2, 'args'),
        t { '):', '\t' },
        i(0),
    }),

    -- Main check
    s('main', {
        t {
            'if __name__ == "__main__":',
            '\t',
        },
        i(0),
    }),
}
