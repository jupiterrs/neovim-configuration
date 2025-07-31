local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
    -- Competitive Programming Snippet
    s('begc', {
        t {
            '#include <iostream>',
            '#include <iomanip>',
            '#include <vector>',
            '#include <cmath>',
            '#include <stdlib.h>',
            '#include <string>',
            '',
            '',
            'int main() {',
            '',
            '    return 0;',
            '',
            '}',
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
